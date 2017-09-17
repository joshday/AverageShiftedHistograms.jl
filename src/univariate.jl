mutable struct Ash{R <: Range, F <: Function}
    density::Vector{Float64}    # ash estimate
    x::R                        # range of x values
    counts::Vector{Int}         # histogram estimate
    kernel::F                   # kernel function
    m::Int                      # smoothing parameter
    nobs::Int                   # number of observations
    function Ash(x::R, kernel::F, m::Int) where {R<:Range, F<:Function}
        m > 0 || throw(ArgumentError("Smoothing parameter must be > 0"))
        new{R, F}(zeros(Float64, length(x)), x, zeros(Int, length(x)), kernel, m, 0)
    end
end
function Base.show(io::IO, o::Ash)
    f, l, s = round.((first(o.x), last(o.x), step(o.x)), 4)
    println(io, "  > edges  : first=$f, last=$l, step=$s")
    println(io, "  > kernel : $(o.kernel)")
    println(io, "  > m      : $(o.m)")
    println(io, "  > nobs   : $(o.nobs)")
    print(io, UnicodePlots.lineplot(xy(o)...; grid = false))
end

# add data to the histogram
function _histogram!{T <: Real}(o::Ash, y::AbstractArray{T})
    b = length(o.x)
    a = first(o.x)
    δinv = inv(step(o.x))
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
    b = length(o.x)
    kernel = o.kernel
    density = o.density
    m = o.m
    for k in eachindex(o.x)
        if o.counts[k] != 0
            for i in max(1, k - m + 1):min(b, k + m - 1)
                @inbounds density[i] += o.counts[k] * kernel((i - k) / m)
            end
        end
    end
    denom = 1 / (sum(density) * step(o.x))
    scale!(density, denom)
    return o
end

"""
    ash(y, x::Range = extendrange(y); m = 5, kernel = Kernels.biweight)

Fit an average shifted histogram where:
    - `y` is the data
    - `x` is a range of values where the density should be estimated
    - `m` is a smoothing parameter.  It is the number of adjacent histogram bins on either side used to estimate the density.
    - `kernel` is the kernel used to smooth the estimate

Make changes to the estimate (add more data, change kernel, or change smoothing parameter):

    ash!(o::Ash; kernel = newkernel, m = newm)
    ash!(o::Ash, y; kernel = newkernel, m = newm)
"""
function ash(y::AbstractArray, x = extendrange(y); m = 5, kernel = Kernels.biweight)
    o = Ash(x, kernel, m)
    _histogram!(o, y)
    _ash!(o)
end

# change smoothing parameter and/or kernel
function ash!(o::Ash; m = o.m, kernel = o.kernel)
    o.m = m
    o.kernel = o.kernel
    _ash!(o)
end
# add data, change smoothing parameter and/or kernel
function ash!(o::Ash, y::AbstractArray; m = o.m, kernel = o.kernel)
    o.m = m
    o.kernel = o.kernel
    _histogram!(o, y)
    _ash!(o)
end



xy(o::Ash) = o.x, o.density
nobs(o::Ash) = o.nobs
nout(o::Ash) = nobs(o) - sum(o.counts)
histdensity(o::Ash) = o.counts / (step(o.x) / StatsBase.nobs(o))

Base.mean(o::Ash) = mean(o.x, StatsBase.AnalyticWeights(o.density))
Base.var(o::Ash) = var(o.x, StatsBase.AnalyticWeights(o.density); corrected=true)
Base.std(o::Ash) = sqrt(var(o))


function Base.quantile(o::Ash, τ::Real)
    0 < τ < 1 || throw(ArgumentError("τ must be in (0, 1)"))
    x = o.x
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
# function Distributions.pdf(o::Ash, x::Real)
#     rng = o.rng
#     y = o.y
#     i = searchsortedlast(rng, x)
#     if 1 <= i < length(rng)
#         y[i] + (y[i+1] - y[i]) * (x - rng[i]) / (rng[i+1] - rng[i])
#     else
#         0.0
#     end
# end
# function Distributions.cdf(o::Ash, x::Real)
#     cdf = cumsum(o.y) * step(o.rng)
#     i = searchsortedlast(o.rng, x)
#     if i == 0
#         return 0.0
#     else
#         return cdf[i]
#     end
# end
#
#
@recipe function f(o::Ash)
    label --> ["Histogram Density" "Ash Density"]
    seriestype --> [:sticks :line]
    linewidth --> [1 2]
    alpha --> [.7 1]
    o.x, [histdensity(o) o.density]
end
