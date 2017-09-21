mutable struct Ash2{R1 <: Range, R2 <: Range, F1 <: Function, F2 <: Function}
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
            {F1 <: Function, F2 <: Function, R1 <: Range, R2 <: Range}

        v = zeros(Int, length(rngy), length(rngx))
        z = zeros(Float64, length(rngy), length(rngx))
        new{R1, R2, F1, F2}(kx, ky, rngx, rngy, mx, my, v, z, 0)
    end
end
function Base.show(io::IO, o::Ash2)
    println(io, "Ash2")
    f, l, s = round.((first(o.rngx), last(o.rngx), step(o.rngx)), 4)
    println(io, "X:")
    println(io, "  > edges  | $f : $s : $l")
    println(io, "  > kernel | $(o.kernelx)")
    println(io, "  > m      | $(o.mx)")
    f, l, s = round.((first(o.rngy), last(o.rngy), step(o.rngy)), 4)
    println(io, "Y:")
    println(io, "  > edges  | $f : $s : $l")
    println(io, "  > kernel | $(o.kernely)")
    println(io, "  > m      | $(o.my)")
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
        w[i + my, j + mx] = kernely(i / my) * kernelx(i / mx)
    end
    v, z = o.v, o.z
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


function ash(x::AbstractVector, y::AbstractVector;
        rngx::Range = extendrange(x), rngy::Range = extendrange(y),
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
function ash!(o::Ash2, x::AbstractArray, y::AbstractArray; mx = o.mx, my = o.my,
        kernelx = o.kernelx, kernely = o.kernely)
    o.mx, o.my, o.kernelx, o.kernely = mx, my, kernelx, kernely
    _histogram!(o, x, y)
    _ash!(o)
end


"return ranges and density of biviariate ASH"
xyz(o::Ash2) = (o.rngx, o.rngy, copy(o.z))
StatsBase.nobs(o::Ash2) = o.nobs
nout(o::Ash2) = StatsBase.nobs(o) - sum(o.v)
function Base.mean(o::Ash2)
    meanx = mean(o.rngx, StatsBase.AnalyticWeights(vec(sum(o.z, 1))))
    meany = mean(o.rngy, StatsBase.AnalyticWeights(vec(sum(o.z, 2))))
    [meanx; meany]
end
function Base.var(o::Ash2)
    varx = var(o.rngx, StatsBase.AnalyticWeights(vec(sum(o.z, 1))); corrected=true)
    vary = var(o.rngy, StatsBase.AnalyticWeights(vec(sum(o.z, 2))); corrected=true)
    [varx; vary]
end
Base.std(o::Ash2) = sqrt.(var(o))

@RecipesBase.recipe f(o::Ash2) = o.rngx, o.rngy, o.z
