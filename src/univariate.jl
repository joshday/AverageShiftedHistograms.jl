mutable struct Ash{R <: Range, F <: Function}
    density::Vector{Float64}    # ash estimate
    rng::R                     # range of x values
    counts::Vector{Int}         # histogram estimate
    kernel::F                   # kernel function
    m::Int                      # smoothing parameter
    nobs::Int                   # number of observations
    function Ash(rng::R, kernel::F, m::Int) where {R<:Range, F<:Function}
        m > 0 || throw(ArgumentError("Smoothing parameter must be > 0"))
        new{R, F}(zeros(Float64, length(rng)), rng, zeros(Int, length(rng)), kernel, m, 0)
    end
end
function Base.show(io::IO, o::Ash)
    println(io, "Ash")
    f, l, s = round.((first(o.rng), last(o.rng), step(o.rng)), 4)
    println(io, "  > edges  | $f : $s : $l")
    println(io, "  > kernel | $(o.kernel)")
    println(io, "  > m      | $(o.m)")
    println(io, "  > nobs   | $(o.nobs)")
    print(io, UnicodePlots.lineplot(xy(o)...; grid = false))
end

# add data to the histogram
function _histogram!{T <: Real}(o::Ash, y::AbstractArray{T})
    b = length(o.rng)
    a = first(o.rng)
    δinv = inv(step(o.rng))
    c = o.counts
    for yi in y
        ki = floor(Int, (yi - a) * δinv + 1.5)
        if 1 <= ki <= b
            @inbounds c[ki] += 1
        end
    end
    o.nobs += length(y)
    return
end

# recalculate the ash density
function _ash!(o::Ash)
    b = length(o.rng)
    kernel = o.kernel
    density = o.density
    m = o.m
    for k in eachindex(o.rng)
        if o.counts[k] != 0
            for i in max(1, k - m + 1):min(b, k + m - 1)
                @inbounds density[i] += o.counts[k] * kernel((i - k) / m)
            end
        end
    end
    denom = 1 / (sum(density) * step(o.rng))
    scale!(density, denom)
    return o
end

"""
# Univariate Ash
    ash(x; kw...)

Fit an average shifted histogram to data `x`.  Keyword options are:

- `rng`    : values over which the density will be estimated
- `m`      : Number of adjacent histograms to smooth over
- `kernel` : kernel used to smooth the estimate

# Bivariate Ash
    ash(x, y; kw...)

Fit a bivariate averaged shifted histogram to data vectors `x` and `y`.  Keyword options are:
- `rngx`    : x values where density will be estimated
- `rngy`    : y values where density will be estimated
- `mx`      : smoothing parameter in x direction
- `my`      : smoothing parameter in y direction
- `kernelx` : kernel in x direction
- `kernely` : kernel in y direction

# Mutating an Ash object
Ash objectes can be updated with new data, smoothing parameter(s), or kernel(s).  They cannot, however, change the ranges over which the density is estimated.  It is therefore suggested to err on the side of caution when choosing data endpoints.

    # univariate
    ash!(obj; kw...)
    ash!(obj, newx, kw...)

    # bivariate
    ash!(obj; kw...)
    ash!(obj, newx, newy; kw...)

"""
function ash(x::AbstractArray; rng::Range = extendrange(x), m = 5, kernel = Kernels.biweight)
    o = Ash(rng, kernel, m)
    _histogram!(o, x)
    _ash!(o)
end


"""
    ash!(o::Ash; kw...)
    ash!(o::Ash, newdata; kw...)

Update an Ash estimate with new data, smoothing parameter (keyword `m`), or kernel (keyword `kernel`):
"""
function ash!(o::Ash; m = o.m, kernel = o.kernel)
    o.m = m
    o.kernel = o.kernel
    _ash!(o)
end
function ash!(o::Ash, y::AbstractArray; m = o.m, kernel = o.kernel)
    o.m = m
    o.kernel = o.kernel
    _histogram!(o, y)
    _ash!(o)
end


"return the range and density of a univariate ASH"
xy(o::Ash) = o.rng, o.density

"return the number of observations"
StatsBase.nobs(o::Ash) = o.nobs

"return the number of observations that fell outside of the histogram range"
nout(o::Ash) = StatsBase.nobs(o) - sum(o.counts)

"return the histogram values as a density (intergrates to 1)"
histdensity(o::Ash) = o.counts ./ StatsBase.nobs(o) ./ step(o.rng)

Base.mean(o::Ash) = mean(o.rng, StatsBase.AnalyticWeights(o.density))
Base.var(o::Ash) = var(o.rng, StatsBase.AnalyticWeights(o.density); corrected=true)
Base.std(o::Ash) = sqrt(var(o))

"""
    quantile(o::Ash, q::Real)

Return the approximate `q`-th quantile from the Ash density.
"""
function Base.quantile(o::Ash, τ::Real)
    0 < τ < 1 || throw(ArgumentError("τ must be in (0, 1)"))
    x = o.rng
    cdf = cumsum(o.density) * step(x)
    i = searchsortedlast(cdf, τ)
    if i == 0
        x[1]
    else
        x[i] + (x[i+1] - x[i]) * (τ - cdf[i]) / (cdf[i + 1] - cdf[i])
    end
end
function Base.quantile{T<:Real}(o::Ash, τ::AbstractVector{T})
    [quantile(o, τi) for τi in τ]
end

function Distributions.pdf(o::Ash, x::Real)
    rng = o.rng
    y = o.density
    i = searchsortedlast(rng, x)
    if 1 <= i < length(rng)
        y[i] + (y[i+1] - y[i]) * (x - rng[i]) / (rng[i+1] - rng[i])
    else
        0.0
    end
end
function Distributions.cdf(o::Ash, x::Real)
    cdf = cumsum(o.density) * step(o.rng)
    i = searchsortedlast(o.rng, x)
    if i == 0
        return 0.0
    else
        return cdf[i]
    end
end

@RecipesBase.recipe function f(o::Ash; hist = true)
    h(arr, hist) = hist ? arr : last(arr)

    l = h(["Histogram Density" "Ash Density"], hist)
    s = h([:sticks :line], hist)
    lw = h([1 2], hist)
    a = h([.7 1], hist)
    v = hist ? [histdensity(o) o.density] : o.density

    label --> l
    seriestype --> s
    linewidth --> lw
    alpha --> a
    o.rng, v
end
