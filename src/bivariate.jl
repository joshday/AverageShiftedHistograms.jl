mutable struct Ash2{R1 <: AbstractRange, R2 <: AbstractRange, F1 <: Function, F2 <: Function}
    kernelx::F1
    kernely::F2
    rngx::R1               # rng for x
    rngy::R2               # rng for y
    mx::Int64
    my::Int64
    v::Matrix{Int}      # counts
    z::Matrix{Float64}  # density
    nobs::Int64

    function Ash2(kx::F1, ky::F2, rngx::R1, rngy::R2, mx::Int, my::Int) where
            {F1 <: Function, F2 <: Function, R1 <: AbstractRange, R2 <: AbstractRange}

        v = zeros(Int, length(rngy), length(rngx))
        z = zeros(Float64, length(rngy), length(rngx))
        new{R1, R2, F1, F2}(kx, ky, rngx, rngy, mx, my, v, z, 0)
    end
end
function Base.show(io::IO, o::Ash2)
    println(io, "Ash2")
    f, l, s = round.((first(o.rngx), last(o.rngx), step(o.rngx)), digits=4)
    print(io, "X:")
    println(io, "  > edges  | $f : $s : $l")
    println(io, "    > kernel | $(o.kernelx)")
    println(io, "    > m      | $(o.mx)")
    f, l, s = round.((first(o.rngy), last(o.rngy), step(o.rngy)), digits=4)
    print(io, "Y:")
    println(io, "  > edges  | $f : $s : $l")
    println(io, "    > kernel | $(o.kernely)")
    println(io, "    > m      | $(o.my)")
    print(io, UnicodePlots.spy(reverse(o.z, dims=1)).graphics)
end

function Base.:(==)(o::Ash2, o2::Ash2)
    fns = fieldnames(typeof(o))
    all(getfield.(Ref(o), fns) .== getfield.(Ref(o2), fns))
end

function _histogram!(o::Ash2, x::AbstractVector, y::AbstractVector)
    length(x) == length(y) || throw(ArgumentError("data lengths differ"))
    δx, δy = step(o.rngx), step(o.rngy)
    ax, ay = first(o.rngx), first(o.rngy)
    nx, ny = length(o.rngx), length(o.rngy)
    for i in eachindex(x)
        kx = floor(Int, (x[i] - ax) / δx + 1.5)
        ky = floor(Int, (y[i] - ay) / δy + 1.5)
        if (1 ≤ kx ≤ nx) && (1 ≤ ky ≤ ny)
            o.v[ky, kx] += 1
        end
    end
    o.nobs += length(x)
    return o
end

function _ash!(o::Ash2)
    δx, δy = step(o.rngx), step(o.rngy)
    nx, ny = length(o.rngx), length(o.rngy)
    mx, my = o.mx, o.my
    kernelx, kernely = o.kernelx, o.kernely
    w = zeros(2 * my - 1, 2 * mx - 1)
    for i = (1 - my):(my - 1), j = (1 - mx):(mx - 1)
        w[i + my, j + mx] = kernely(i / my) * kernelx(j / mx)
    end
    v, z = o.v, o.z
    fill!(z, 0.0)
    for k = 1:ny
       for l = 1:nx
           if v[k, l] == 0
                l += 1
            else
                for i = max(1, k - my + 1):min(ny, k + my - 1)
                    for j = max(1, l - mx + 1):min(nx, l + mx - 1)
                        z[i, j] += v[k, l] * w[my + i - k, mx + j - l]
                    end
                end
            end
        end
    end
    # make density integrate to 1
    denom = 1.0 / (sum(o.z) * δx * δy)
    for i in eachindex(z)
        @inbounds z[i] *= denom
    end
    o
end


function ash(x, y; nbin=500, nbinx=nbin, nbiny=nbin,
        rngx::AbstractRange = extendrange(x, nbinx), rngy::AbstractRange = extendrange(y, nbiny),
        mx = 5, my = 5, kernelx = Kernels.biweight, kernely = Kernels.biweight)
    o = Ash2(kernelx, kernely, rngx, rngy, mx, my)
    _histogram!(o, x, y)
    _ash!(o)
    return o
end

function ash!(o::Ash2; mx = o.mx, my = o.my, kernelx = o.kernelx, kernely = o.kernely)
    o.mx, o.my, o.kernelx, o.kernely = mx, my, kernelx, kernely
    _ash!(o)
end
function ash!(o::Ash2, x, y; mx = o.mx, my = o.my,
        kernelx = o.kernelx, kernely = o.kernely)
    o.mx, o.my, o.kernelx, o.kernely = mx, my, kernelx, kernely
    _histogram!(o, x, y)
    _ash!(o)
end


"return ranges and density of biviariate ASH"
xyz(o::Ash2) = (o.rngx, o.rngy, copy(o.z))
nobs(o::Ash2) = o.nobs
nout(o::Ash2) = nobs(o) - sum(o.v)
function Statistics.mean(o::Ash2)
    meanx = mean(o.rngx, fweights(vec(sum(o.v, dims=1))))
    meany = mean(o.rngy, fweights(vec(sum(o.v, dims=2))))
    [meanx; meany]
end
function Statistics.var(o::Ash2)
    varx = var(o.rngx, fweights(vec(sum(o.v, dims=1))); corrected=true)
    vary = var(o.rngy, fweights(vec(sum(o.v, dims=2))); corrected=true)
    [varx; vary]
end

"""
    pdf(o::Ash2, x::Real, y::Real)
Return the estimated density at the point `(x, y)`.
"""
function pdf(o::Ash2, x::Real, y::Real)
    z = o.z
    rx = o.rngx
    ry = o.rngy
    i = searchsortedlast(rx, x)
    j = searchsortedlast(ry, y)
    # Bilinear interpolation
    if 1 <= i < length(rx) && 1 <= j < length(ry)
        ([rx[i+1]-x x-rx[i]]*[z[i, j] z[i, j+1]; z[i+1, j] z[i+1, j+1]]*[ry[j+1]-y; y-ry[j]])[1]/((rx[i+1]-rx[i])*(ry[j+1]-ry[j]))
    else
        0.0
    end
end

Statistics.std(o::Ash2) = sqrt.(var(o))

RecipesBase.@recipe function f(o::Ash2; hist=false)
    seriestype --> :heatmap
    o.rngx, o.rngy, (hist ? o.v : o.z)
end
