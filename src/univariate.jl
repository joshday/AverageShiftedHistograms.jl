type Ash{F <: Function, R <: Range} <: AbstractAsh
    kernel::F
    rng::R                      # x values where you want density y = f(x)
    v::Vector{Int64}            # v[i] is the count at x[i]
    y::Vector{Float64}          # y[i] is the density at x[i]
    m::Int64                    # smoothing parameter
    nobs::Int64
end
function Ash(
        kernel::Function, rng::Range, v::Vector{Int64},
        y::Vector{Float64}, m::Int64, n::Int64
    )
    @assert kernel(0.1) > 0.0 && kernel(-0.1) > 0.0 "kernel must always be positive"
    @assert length(rng) > 1 "Need at least two bins"
    @assert length(v) == length(y) == length(rng)
    @assert m > 0 "Smoothing parameter must be positive"
    Ash{typeof(kernel), typeof(rng)}(kernel, rng, v, y, m, n)
end
function Base.show(io::IO, o::Ash)
    println(io, typeof(o))
    println(io, "  > m         : ", o.m)
    println(io, "  > kernel    : ", o.kernel)
    println(io, "  > edges     : ", o.rng)
    println(io, "  > nobs      : ", StatsBase.nobs(o))
    plt = UnicodePlots.lineplot(xy(o)...; grid = false)
    show(io, plt)
end

function ash(
        x::Vector, rng::Range = extendrange(x);
        kernel::Function = Kernels.biweight, m::Int64 = 5, warnout::Bool = true
    )
    d = length(rng)
    v = zeros(Int64, d)
    y = zeros(d)
    o = Ash(kernel, rng, v, y, m, 0)
    update!(o, x)
    ash!(o; warnout = warnout)
end

# Return the histogram (as density)
histdensity(o::Ash) = o.v / step(o.rng) / StatsBase.nobs(o)
# StatsBase.nobs(o::Ash) = o.nobs
# nout(o::Ash) = nobs(o) - sum(o.v)
xy(o::Ash) = collect(o.rng), o.y
function extendrange(y::Vector)
    σ = std(y)
    linspace(minimum(y) - .5 * σ, maximum(y) + .5 * σ, 150)
end
Base.mean(o::Ash) = mean(o.rng, StatsBase.WeightVec(o.y))
Base.var(o::Ash) = var(o.rng, StatsBase.WeightVec(o.y))
Base.std(o::Ash) = sqrt(var(o))
function Base.quantile(o::Ash, τ::Real)
    @assert 0 < τ < 1
    rng = o.rng
    cdf = cumsum(o.y) * step(rng)
    i = searchsortedlast(cdf, τ)
    if i == 0
        rng[1]
    else
        rng[i] + (rng[i+1] - rng[i]) * (τ - cdf[i]) / (cdf[i+1] - cdf[i])
    end
end
function Base.quantile{T<:Real}(o::Ash, τ::AbstractVector{T})
    [quantile(o, τi) for τi in τ]
end
function Distributions.pdf(o::Ash, x::Real)
    rng = o.rng
    y = o.y
    i = searchsortedlast(rng, x)
    if 1 <= i < length(rng)
        y[i] + (y[i+1] - y[i]) * (x - rng[i]) / (rng[i+1] - rng[i])
    else
        0.0
    end
end
function Distributions.cdf(o::Ash, x::Real)
    cdf = cumsum(o.y) * step(o.rng)
    i = searchsortedlast(o.rng, x)
    if i == 0
        return 0.0
    else
        return cdf[i]
    end
end



# Add data
function update!(o::Ash, x::Vector)
    rng = o.rng
    δinv = 1.0 / step(rng)
    a = first(rng)
    nbin = length(rng)
    o.nobs += length(x)
    for xi in x
        # This line below is different from the paper because the input to UnivariateASH
        # is the points where you want the estimate, NOT the bin edges.
        ki = floor(Int, (xi - a) * δinv + 1.5)
        if 1 <= ki <= nbin
            @inbounds o.v[ki] += 1
        end
    end
    o
end

# Compute the density
function ash!(o::Ash; m::Int = o.m, kernel::Function = o.kernel, warnout::Bool = true)
    o.m = m
    o.kernel = kernel
    δ = step(o.rng)
    nbin = length(o.rng)
    @inbounds for k = 1:nbin
        if o.v[k] != 0
            for i = max(1, k - m + 1):min(nbin, k + m - 1)
                o.y[i] += o.v[k] * kernel((i - k) / m)
            end
        end
    end
    # make y integrate to 1
    y = o.y
    denom = 1.0 / (sum(y) * δ)
    for i in eachindex(y)
        @inbounds y[i] *= denom
    end
    warnout && (o.y[1] != 0 || o.y[end] != 0) && warn("nonzero density outside of bounds")
    o
end

function StatsBase.fit!(o::Ash, x::AbstractVector; kw...)
    update!(o, x)
    ash!(o; kw...)
end


@recipe function f(o::Ash)
    label --> ["Histogram Density" "Ash Density"]
    seriestype --> [:sticks :line]
    linewidth --> [1 2]
    alpha --> [.7 1]
    o.rng, [histdensity(o) o.y]
end
