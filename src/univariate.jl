#-----------------------------------------------------------------------# FastHistogram
struct FastHistogram{R <: Range}
    v::Vector{Int}
    x::R
    n::Int64
end
function FastHistogram(data::AVec{<:Real}, x::Range = extendrange(data))
    b = length(x)
    v = zeros(Int, b)
    a = first(x)
    δinv = inv(step(x))
    for yi in data
        ki = floor(Int, (yi - a) * δinv + 1.5)
        if 1 <= ki <= b
            @inbounds v[ki] += 1
        end
    end
    FastHistogram(v, x, length(data))
end
xy(o::FastHistogram) = o.x, o.v
function Base.show(io::IO, o::FastHistogram)
    println(io, name(o))
    f, l, s = round.((first(o.x), last(o.x), step(o.x)), 4)
    println(io, "  > edges : first=$f, last=$l, step=$s")
    println(io, "  > nobs  : $(nobs(o))")
    print(io, UnicodePlots.lineplot(xy(o)...; grid = false))
end
nobs(o::FastHistogram) = o.n
nout(o::FastHistogram) = nobs(o) - sum(o.v)

#-----------------------------------------------------------------------# Ash
struct Ash{F <: Function, H <: FastHistogram} <: AbstractAsh{1}
    h::H
    m::Int
    kernel::F
    y::Vector{Float64}
end
function Ash(h::FastHistogram; kernel::Function = Kernels.biweight, m::Int = 5)
    b = length(h.x)
    y = zeros(b)
    for k in eachindex(h.x)
        if h.v[k] != 0
            for i in max(1, k-m+1):min(b, k+m-1)
                @inbounds y[i] += h.v[k] * kernel((i-k) / m)
            end
        end
    end
    denom = 1 / (sum(y) * step(h.x))
    scale!(y, denom)
    Ash(h, m, kernel, y)
end
function Base.show(io::IO, a::Ash)
    println(io, name(a))
    println(io, "  > m      : ", a.m)
    print(io, a.h)
end
nobs(a::Ash) = StatsBase.nobs(a.h)
nout(a::Ash) = StatsBase.nobs(a) - sum(a.h.y)


# Return the histogram (as density)
histdensity(o::Ash) = o.v / (step(o.rng) / StatsBase.nobs(o))
xy(o::Ash) = o.h.x, o.y
Base.mean(o::Ash) = mean(o.h.x, StatsBase.Weights(o.y))
Base.var(o::Ash) = var(o.rng, StatsBase.Weights(o.y))
Base.std(o::Ash) = sqrt(var(o))
# function Base.quantile(o::Ash, τ::Real)
#     @assert 0 < τ < 1
#     rng = o.rng
#     cdf = cumsum(o.y) * step(rng)
#     i = searchsortedlast(cdf, τ)
#     if i == 0
#         rng[1]
#     else
#         rng[i] + (rng[i+1] - rng[i]) * (τ - cdf[i]) / (cdf[i+1] - cdf[i])
#     end
# end
# function Base.quantile{T<:Real}(o::Ash, τ::AbstractVector{T})
#     [quantile(o, τi) for τi in τ]
# end
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
#
# # Add data
# function update!(o::Ash, x::Vector)
#     rng = o.rng
#     δinv = 1.0 / step(rng)
#     a = first(rng)
#     nbin = length(rng)
#     o.nobs += length(x)
#     for xi in x
#         # This line below is different from the paper because the input to UnivariateASH
#         # is the points where you want the estimate, NOT the bin edges.
#         ki = floor(Int, (xi - a) * δinv + 1.5)
#         if 1 <= ki <= nbin
#             @inbounds o.v[ki] += 1
#         end
#     end
#     o
# end
#
# # Compute the density
# function ash!(o::Ash; m::Int = o.m, kernel::Function = o.kernel, warnout::Bool = true)
#     o.m = m
#     o.kernel = kernel
#     δ = step(o.rng)
#     nbin = length(o.rng)
#     @inbounds for k = 1:nbin
#         if o.v[k] != 0
#             for i = max(1, k - m + 1):min(nbin, k + m - 1)
#                 o.y[i] += o.v[k] * kernel((i - k) / m)
#             end
#         end
#     end
#     # make y integrate to 1
#     y = o.y
#     denom = 1.0 / (sum(y) * δ)
#     for i in eachindex(y)
#         @inbounds y[i] *= denom
#     end
#     warnout && (o.y[1] != 0 || o.y[end] != 0) && warn("nonzero density outside of bounds")
#     o
# end
#
# function StatsBase.fit!(o::Ash, x::AbstractVector; kw...)
#     update!(o, x)
#     ash!(o; kw...)
# end
#
#
# @recipe function f(o::Ash)
#     label --> ["Histogram Density" "Ash Density"]
#     seriestype --> [:sticks :line]
#     linewidth --> [1 2]
#     alpha --> [.7 1]
#     o.rng, [histdensity(o) o.y]
# end
