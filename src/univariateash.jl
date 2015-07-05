#===================================================================================#
# Univariate Average Shifted Histograms
#
# This allows users to create an ASH estimate from a variety of contructors and
# fit methods.  You can get approximate mean, var, and std from UnivariateASH.
# TODO: quantiles, pdf, cdf
#
# Change the smoothing parameter `m` and `kernel` using ash!()
#===================================================================================#

const kernellist = [:uniform, :triangular, :epanechnikov, :biweight,
                    :triweight, :tricube, :gaussian, :cosine, :logistic]
const default_kernel = :biweight

#-------------------------------------------------------------# type and constructors
type UnivariateASH
    edges::AbstractVector   # hist(y, edges)[1]
    counts::Array{Int}      # hist(y, edges)[2]
    v::Vector{Float64}      # UnivariateASH estimate
    m::Int                  # smoothing parameter
    kernel::Symbol          # kernel
    n::Int                  # number of observations

    function UnivariateASH(e::AbstractVector, counts::Array{Int}, v::Vector{Float64}, m::Int, kernel::Symbol, n::Int)
        n >= 0 || error("n can't be negative")
        m >= 1 || error("smoothing parameter m must be at least 1")
        kernel ∈ kernellist || error("kernel not recognized")
        length(v) == length(e) - 1 || error("length(v) must be one less than length(hist.edges)")
        new(e, counts, v, m, kernel, n)
    end
end

function UnivariateASH(edg::AbstractVector, m::Int, kernel::Symbol = default_kernel)
    UnivariateASH(edg, zeros(Int, length(edg) - 1), zeros(length(edg) - 1), m, kernel, 0)
end

function fit(::Type{UnivariateASH}, y::Vector{Float64}, edg::AbstractVector, m::Int, kernel::Symbol = default_kernel)
    o = UnivariateASH(edg, m, kernel)
    update!(o, y)
    o
end

function update!(o::UnivariateASH, y::Vector{Float64}, args...)
    Base.hist!(o.counts, y, o.edges, init = false)
    ash!(o, args...)
    o.n += length(y)
end

nobs(o::UnivariateASH) = o.n
nout(o::UnivariateASH) = nobs(o) - sum(o.counts)

function ash!(o::UnivariateASH, m::Int = o.m, kernel::Symbol = o.kernel; warnout = true)
    o.m = m
    o.kernel = kernel
    nbins = length(o.edges) - 1
    @compat δ = Float64(o.edges[2] - o.edges[1])
    for k = 1:nbins
        if o.counts[k] != 0
            for i = maximum([1, k - o.m + 1]):minimum([nbins, k + o.m - 1])
                o.v[i] += o.counts[k] * kernels[o.kernel]((i - k) / o.m)
            end
        end
    end

    o.v /= sum(o.v) * δ  # make y integrate to 1
    o.v[1] != 0 || o.v[end] != 0 && warn("nonzero density outside of bounds")
    return
end




#
# # Constructor with data
# function UnivariateASH(y::Vector, edg::AbstractVector, m::Int;
#                        closed::Symbol = :right,
#                        bintype::Type = Int,
#                        kernel::Symbol = default_kernel)
#     o = UnivariateASH(edg, m, closed = closed, bintype = bintype, kernel = kernel)
#     update!(o, y)
#     o
# end

#-------------------------------------------------------------------------------# fit
# function fit(::Type{UnivariateASH}, y::Vector, w::WeightVec, edg::AbstractVector, m::Int;
#              closed::Symbol = :right, kernel::Symbol = default_kernel)
#     h = fit(Histogram, y, w, edg, closed = closed)
#     o = UnivariateASH(h, zeros(length(edg) - 1), m, kernel, 0)
#     update!(o, y)
#     o
# end
#
# function fit(::Type{UnivariateASH}, y::Vector, edg::AbstractVector, m::Int;
#              closed::Symbol = :right, kernel::Symbol = default_kernel)
#     h = fit(Histogram, y, edg, closed = closed)
#     o = UnivariateASH(h, zeros(length(edg) - 1), m, kernel, 0)
#     update!(o, y)
#     o
# end

#---------------------------------------------------------------------------# update!
# function update!(o::UnivariateASH, y::Real, ash::Bool = true)
#     push!(o.hist, y)
#     o.n += 1
#     ash && ash!(o)
# end
#
# function update!{T <: Real}(o::UnivariateASH, y::Vector{T})
#     for yi in y; update!(o, yi, false); end
#     ash!(o)
# end
#
# function updatebatch!{T<:Real}(o::UnivariateASH, y::Vector{T})
#     append!(o.hist, y)
#     o.n += length(y)
#     ash!(o)
# end


#------------------------------------------------------------------------------# Base
function Base.show(io::IO, o::UnivariateASH)
    println(io, typeof(o))
    println(io, "*  kernel: ", o.kernel)
    println(io, "*       m: ", o.m)
    println(io, "*   nbins: ", length(o.edges - 1))
    println(io, "*    nobs: ", nobs(o))
    maximum(o.counts) > 0 && TextPlots.plot([midpoints(o)], o.v, title = false, cols=30, rows=10)
end
#
# Base.copy(o::UnivariateASH) = deepcopy(o)
#
# function Base.merge!(o::UnivariateASH)
#     # TODO
# end
#
# Base.merge(o::UnivariateASH) = merge!(copy(o))


#-----------------------------------------------------------------# functions/methods
# value(o::UnivariateASH) = copy(o.v)
midpoints(o::UnivariateASH) = midpoints(o.edges)
#
# mean(o::UnivariateASH) = mean(midpoints(o), WeightVec(o.v))
# var(o::UnivariateASH) = var(midpoints(o), WeightVec(o.v))
# std(o::UnivariateASH) = sqrt(var(o))
#
# function quantile(o::UnivariateASH, τ::Real)
#     τ > 0 && τ < 1 || error("τ must be in (0, 1)")
#     cdf = cumsum(o.v) * (o.hist.edges[1][2] - o.hist.edges[1][1])
#
#     midpoints(o)[minimum(find(cdf .>= τ))]
# end
#
# function ash!(o::UnivariateASH, m::Int = o.m, kernel::Symbol = o.kernel; warnout = true)
#     o.m = m
#     o.kernel = kernel
#     nbins = length(o.hist.edges[1]) - 1
#     @compat δ = Float64((o.hist.edges[1][2] - o.hist.edges[1][1]))
#     @inbounds for k = 1:nbins
#         if o.hist.weights[k] != 0
#             @inbounds for i = maximum([1, k - o.m + 1]):minimum([nbins, k + o.m - 1])
#                 o.v[i] += o.hist.weights[k] * kernels[o.kernel]((i - k) / o.m)
#             end
#         end
#     end
#
#     o.v /= sum(o.v) * δ  # make y integrate to 1
#     o.v[1] != 0 || o.v[end] != 0 && warn("nonzero density outside of bounds")
#     return
# end







a = AverageShiftedHistograms
o = a.UnivariateASH(-4:.1:4, 5)
y = randn(100_000)
@time o = a.fit(a.UnivariateASH, y, -4:.1:4, 5)
o = a.fit(a.UnivariateASH, randn(1000), linspace(-4, 4, 100), 5)
show(o)
