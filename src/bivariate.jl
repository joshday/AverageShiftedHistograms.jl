# Pseudocode: http://www.stat.rice.edu/%7Escottdw/stat550/HW/hw4/c05.pdf

type MVAsh{F1 <: Function, F2 <: Function, R1 <: Range, R2 <: Range} <: AbstractAsh
    kernelx::F1
    kernely::F2
    rngx::R1
    rngy::R2
    mx::Int64
    my::Int64
    v::Matrix{Int}
    z::Matrix{Float64}
    nobs::Int64
end

function MVAsh(
        kernelx::Function, kernely::Function, rngx::Range, rngy::Range,
        mx::Int64, my::Int64, v::Matrix{Int}, z::Matrix{Float64}, nobs::Int64
        )
    @assert kernelx(0.1) > 0.0 && kernelx(-0.1) > 0.0 "kernelx must always be positive"
    @assert kernely(0.1) > 0.0 && kernely(-0.1) > 0.0 "kernely must always be positive"
    @assert length(rngx) > 1 "Need at least two bins"
    @assert length(rngy) > 1 "Need at least two bins"
    @assert length(rngx) == size(v, 2) == size(z, 2)
    @assert length(rngy) == size(v, 1) == size(z, 1)
    @assert mx > 0 "Smoothing parameter mx must be positive"
    @assert my > 0 "Smoothing parameter my must be positive"
    MVAsh(kernelx, kernely, rngx, rngy, mx, my, v, z, nobs)
end
function Base.show(io::IO, o::MVAsh)
    println(io, typeof(o))
    println(io, "  > X")
    println(io, "    - m      : ", o.mx)
    println(io, "    - kernel : ", o.kernelx)
    println(io, "    - edges  : ", o.rngx)
    println(io, "  > Y")
    println(io, "    - m      : ", o.my)
    println(io, "    - kernel : ", o.kernely)
    println(io, "    - edges  : ", o.rngy)
end

function ash(
        x::Vector, y::Vector,
        rngx::Range = extendrange(x, .4, 100), rngy::Range = extendrange(y, .4, 100);
        mx::Int = 5, my::Int = 5,
        kernelx::Function = Kernels.biweight, kernely::Function = Kernels.biweight,
        warnout::Bool = true
    )
    ncol, nrow = length(rngx), length(rngy)
    o = MVAsh(
        kernelx, kernely, rngx, rngy, mx, my,
        zeros(Int64, nrow, ncol), zeros(nrow, ncol), 0
    )
    update!(o, x, y)
    ash!(o; warnout = warnout)
 end

function update!(o::MVAsh, x::AbstractVector, y::AbstractVector)
    n = length(x)
    @assert n == length(y)
    δx, δy = step(o.rngx), step(o.rngy)
    ax, ay = o.rngx[1], o.rngy[1]
    nbinx, nbiny = length(o.rngx), length(o.rngy)

    for i in 1:n
        kx = floor(Int, (x[i] - ax) / δx + 1.5)
        ky = floor(Int, (y[i] - ay) / δy + 1.5)
        if 1 <= kx <= nbinx && 1 <= ky <= nbiny
            o.v[ky, kx] += 1
        end
    end
    o.nobs += n
    o
end

function ash!(o::MVAsh;
        mx::Int64 = o.mx, my::Int64 = o.my,
        kernelx::Function = o.kernelx, kernely::Function = o.kernely,
        warnout::Bool = true
    )
    o.mx, o.my, o.kernelx, o.kernely = mx, my, kernelx, kernely
    δx, δy = step(o.rngx), step(o.rngy)
    nbinx, nbiny = length(o.rngx), length(o.rngy)

    w = zeros(2 * my - 1, 2 * mx - 1)
    for i = (1 - my):(my - 1), j = (1 - mx):(mx - 1)
        w[i + my, j + mx] = kernely(i / my) * kernelx(i / mx)
    end

    v, z = o.v, o.z
    for k = 1:nbiny
       for l = 1:nbinx
           if v[k, l] == 0
                l += 1
            else
                for i = max(1, k - my + 1):min(nbiny, k + my - 1)
                    for j = max(1, l - mx + 1):min(nbinx, l + mx - 1)
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

    if warnout
        any(z[end, :] .!= 0)    && warn("nonzero density outside bounds at minimum(rngy)")
        any(z[1, :] .!= 0)      && warn("nonzero density outside bounds at maximum(rngy)")
        any(z[:, 1] .!= 0)      && warn("nonzero density outside bounds at minimum(rngx)")
        any(z[:, end] .!= 0)    && warn("nonzero density outside bounds at maximum(rngx)")
    end
    o
end

xyz(o::MVAsh) = (collect(o.rngx), collect(o.rngy), copy(o.z))
function StatsBase.fit!(o::MVAsh, x::AbstractVector, y::AbstractVector; kw...)
    updatebin!(o, x, y)
    ash!(o; kw...)
end
function Base.mean(o::MVAsh)
    meanx = mean(o.rngx, StatsBase.WeightVec(vec(sum(o.z, 1))))
    meany = mean(o.rngy, StatsBase.WeightVec(vec(sum(o.z, 2))))
    [meanx; meany]
end
function Base.var(o::MVAsh)
    varx = var(o.rngx, StatsBase.WeightVec(vec(sum(o.z, 1))))
    vary = var(o.rngy, StatsBase.WeightVec(vec(sum(o.z, 2))))
    [varx; vary]
end
Base.std(o::MVAsh) = sqrt(var(o))

@recipe function f(o::MVAsh)
    seriestype --> :heatmap
    o.z
end
