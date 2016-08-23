type Ash{F <: Function, R <: Range{Float64}}
    kernel::F
    rng::R                      # x values where you want density y = f(x)
    v::Vector{Int64}            # v[i] is the count at x[i]
    y::Vector{Float64}          # y[i] is the density at x[i]
    m::Int64                    # smoothing parameter
end
function Ash(
        kernel::Function, rng::FloatRange{Float64}, v::Vector{Int64},
        y::Vector{Float64}, m::Int64
    )
    @assert kernel(0.1) > 0.0 && kernel(-0.1) > 0.0 "kernel must always be positive"
    @assert length(rng) > 1 "Need at least two bins"
    @assert length(v) == length(y) == length(rng)
    @assert m > 0 "Smoothing parameter must be positive"
    Ash(kernel, rng, v, y, m)
end
function Base.show(io::IO, o::Ash)
    println(io, typeof(o))

    plt = UnicodePlots.lineplot(xy(o)...; grid=false)
    # UnicodePlots.lineplot!(plt, o.rng, histdensity(o))
    show(io, plt)
end

function ash(
        x::Vector, rng::Range{Float64} = extendrange(y);
        kernel::Function = biweight, m::Int64 = 5
    )
    d = length(rng)
    v = zeros(Int64, d)
    y = zeros(d)
    o = Ash(kernel, rng, v, y, m)
    update!(o, x)
    ash!(o)
end

histdensity(o::Ash) = o.v / step(o.rng) / StatsBase.nobs(o)
StatsBase.nobs(o::Ash) = sum(o.v)
xy(o::Ash) = collect(o.rng), o.y

# Add data to the
function update!(o::Ash, x::Vector)
    rng = o.rng
    δinv = 1.0 / step(rng)
    a = first(rng)
    nbin = length(rng)
    for yi in y
        # This line below is different from the paper because the input to UnivariateASH
        # is the points where you want the estimate, NOT the bin edges.
        ki = floor(Int, (yi - a) * δinv + 1.5)
        if 1 <= ki <= nbin
            @inbounds o.v[ki] += 1
        end
    end
    o
end

# compute the density
function ash!(o::Ash; m::Int = o.m, kernel::Function = o.kernel, warnout::Bool = true)
    o.m = m
    o.kernel = kernel
    δ = step(o.rng)
    nbin = length(o.rng)
    for k = 1:nbin
        if o.v[k] != 0
            for i = maximum([1, k - o.m + 1]):minimum([nbin, k + o.m - 1])
                o.y[i] += o.v[k] * o.kernel((i - k) / o.m)
            end
        end
    end
    # make y integrate to 1
    y = o.y
    denom = 1.0 / (sum(y) * δ)
    for i in eachindex(y)
        y[i] *= denom
    end
    warnout && (o.y[1] != 0 || o.y[end] != 0) && warn("nonzero density outside of bounds")
    o
end



function extendrange(y::Vector)
    σ = std(y)
    linspace(minimum(y) - σ, maximum(y) + σ, 200)
end


#TEST
y = randn(1000)
o = ash(y)
show(o)


# #---------------------------------------------------------------------# UnivariateASH
# type UnivariateASH <: ASH
#     rng::FloatRange{Float64}    # x values for which you want to find density y = f(x)
#     v::Vector{Int}              # Counts in each bin
#     y::VecF                     # density y = f(x)
#     m::Int                      # smoothing parameter
#     kernel::Symbol              # kernel
#     n::Int                      # number of observations
#     function UnivariateASH(rng::FloatRange{Float64}, m::Int = 5, kernel::Symbol = :biweight)
#         l = length(rng)
#         l >= 2 || error("need at least 2 bins!")
#         m >= 0 || error("smoothing parameter must be nonnegative")
#         kernel in kernellist || error("kernel not recognized")
#         new(rng, zeros(Int, l), zeros(l), m, kernel, 0.0)
#     end
# end
#
# """
# Create a UnivariateASH or BivariateASH object from data.
#
# ### UnivariateASH
#
#     ash(y, rng; m = 5, kernel = :biweight)
#     ash(y; nbin = 1000, r = 0.2, ...)
#
# Calculate the density at each element in `rng` using smoothing parameter `m` and
# kernel `kernel`.  Alternatively, supply the number of histogram bins `nbin` and
# a multiplier `r` to determine endpoints.  Endpoints extend the extrema of `y` by
# `r` times its range: `r * (maximum(y) - minimum(y))`.
#
#
# ### BivariateASH
#
#     ash(x, y, rngx, rngy; mx = 5, my = 5, kernelx = :biweight, kernely = :biweight)
#     ash(x, y; nbinx = 1000, nbiny = 1000, r = 0.2, ...)
#
# Arguments work similarly to their univariate equivalents.
# """
# function ash(y::AVecF, rng::Range; m::Int = 5, kernel::Symbol = :biweight)
#     myrng = FloatRange(first(rng), step(rng), length(rng), Float64(rng.divisor))
#     o = UnivariateASH(rng, m, kernel)
#     updatebin!(o, y)
#     ash!(o)
#     o
# end
#
# function ash(y::AVecF; nbin::Int = 200, r::Real = 0.2, m::Int = 5, kernel::Symbol = :biweight)
#     r > 0 || error("r must be positive")
#     a, b = extrema(y)
#     rng = b - a
#     a -= r * rng
#     b += r * rng
#     step = (b - a) / nbin
#     ash(y, a:step:b, m = m, kernel = kernel)
# end
#
#
# function updatebin!(o::UnivariateASH, y::AVecF)
#     rng = o.rng
#     δinv = rng.divisor / rng.step
#     a = first(rng)
#     nbin = length(rng)
#     o.n += length(y)
#     for yi in y
#         # This line below is different from the paper because the input to UnivariateASH
#         # is the points where you want the estimate and not the bin edges.
#         ki = floor(Int, (yi - a) * δinv + 1.5)
#         if 1 <= ki <= nbin
#             @inbounds o.v[ki] += 1
#         end
#     end
# end
#
#
# """
# ### Change UnivariateASH parameters
#
# `ash!(o; kwargs...)`
#
# Possible arguments are:
#
# - `m`: smoothing parameter
# - `kernel`: smoothing kernel
# - `warnout`: warn if there is nonzero density on the edge of the estimate
# """
# function ash!(o::UnivariateASH; m::Int = o.m, kernel::Symbol = o.kernel, warnout::Bool = true)
#     o.m = m
#     o.kernel = kernel
#     δ = o.rng.step / o.rng.divisor
#     nbin = length(o.rng)
#     for k = 1:nbin
#         if o.v[k] != 0
#             for i = maximum([1, k - o.m + 1]):minimum([nbin, k + o.m - 1])
#                 o.y[i] += o.v[k] * kernels[o.kernel]((i - k) / o.m)
#             end
#         end
#     end
#
#     o.y /= sum(o.y) * δ  # make y integrate to 1
#     warnout && (o.y[1] != 0 || o.y[end] != 0) && warn("nonzero density outside of bounds")
#     o
# end
#
#
# """
# ### Update a UnivariateASH or BivariateASH object with more data.
#
# UnivariateASH:
# ```
# fit!(o, y; warnout = true)
# ```
#
# BivariateASH:
# ```
# fit!(o, x, y; warnout = true)
# ```
# """
# function StatsBase.fit!(o::UnivariateASH, y::AVecF; warnout = true)
#     updatebin!(o, y)
#     ash!(o, warnout = warnout)
#     o
# end
#
# Base.copy(o::UnivariateASH) = deepcopy(o)
#
# function Base.merge!(o1::UnivariateASH, o2::UnivariateASH)
#     o1.rng == o2.rng || error("ranges do not match!")
#     o1.m == o2.m || warn("smoothing parameters don't match.  Using m = $o1.m")
#     o1.kernel == o2.kernel || warn("kernels don't match.  Using kernel = $o1.kernel")
#     o1.n += o2.n
#     o1.v += o2.v
#     ash!(o1)
# end
#
# function Base.show(io::IO, o::UnivariateASH)
#     println(io, typeof(o))
#     println(io, "  >  kernel: ", o.kernel)
#     println(io, "  >       m: ", o.m)
#     println(io, "  >   edges: ", o.rng)
#     println(io, "  >    nobs: ", StatsBase.nobs(o))
#     if maximum(o.y) > 0
#         x, y = xy(o)
#         xlim = [minimum(x), maximum(x)]
#         ylim = [0, maximum(y)]
#         myplot = UnicodePlots.lineplot(x, y, xlim=xlim, ylim=ylim, name = "density")
#         show(io, myplot)
#     end
# end
#
# StatsBase.nobs(o::ASH) = o.n
#
# nout(o::UnivariateASH) = o.n - sum(o.v)
# Base.mean(o::UnivariateASH) = mean(collect(o.rng), StatsBase.WeightVec(o.y))
# Base.var(o::UnivariateASH) = var(collect(o.rng), StatsBase.WeightVec(o.y))
# Base.std(o::UnivariateASH) = sqrt(var(o))
# xy(o::UnivariateASH) = (collect(o.rng), copy(o.y))
#
# function Base.quantile(o::UnivariateASH, τ::Real)
#     0 < τ < 1 || error("τ must be in (0, 1)")
#     cdf = cumsum(o.y) * (o.rng.step / o.rng.divisor)
#     i = searchsortedlast(cdf, τ)
#     if i == 0
#         o.rng[1]
#     else
#         o.rng[i] + (o.rng[i+1] - o.rng[i]) * (τ - cdf[i]) / (cdf[i+1] - cdf[i])
#     end
# end
#
# function Base.quantile{T <: Real}(o::UnivariateASH, τ::Vector{T} = [.25, .5, .75])
#     [quantile(o, τi) for τi in τ]
# end
#
#
# function Distributions.pdf(o::UnivariateASH, x::Real)
#     i = searchsortedlast(o.rng, x)
#     if 1 <= i < length(o.rng)
#         o.y[i] + (o.y[i+1] - o.y[i]) * (x - o.rng[i]) / (o.rng[i+1] - o.rng[i])
#     else
#         0.0
#     end
# end
#
# function Distributions.pdf{T <: Real}(o::UnivariateASH, x::Array{T})
#     for xi in x
#         Distributions.pdf(o, xi)
#     end
# end
