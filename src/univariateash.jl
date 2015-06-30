#=============================================================================#
# Univariate Average Shifted Histograms
#
# This allows users to create an ASH estimate from a variety of contructors and
# fit methods.  You can get approximate mean, var, and std from UnivariateASH.
# TODO: quantiles, pdf, cdf
#
# Change the smoothing parameter `m` and `kernel` using ash!()
#=============================================================================#

const kernellist = [:uniform, :triangular, :epanechnikov, :biweight,
                    :triweight, :tricube, :gaussian, :cosine, :logistic]
const default_kernel = :biweight

#-------------------------------------------------------# type and constructors
type UnivariateASH{T<:Real}
    hist::Histogram{T, 1}             # bins
    v::Vector{Float64}                # UnivariateASH estimate
    m::Int                            # smoothing parameter
    kernel::Symbol                    # kernel
    n::Int                            # number of observations

    function UnivariateASH(hist::Histogram{T, 1}, v::Vector{Float64}, m::Int, kernel::Symbol, n::Int)
        n >= 0 || error("n must be greater than or equal to 0")
        m > 0 || error("smoothing parameter m must be greater than 0")
        kernel ∈ kernellist || error("kernel not recognized")
        length(v) == length(hist.edges[1]) - 1 || error("length(v) must be one less than length(hist.edges)")
        new(hist, v, m, kernel, n)
    end
end

# Default outer constructor.  This isn't generated because of the inner constructor.
function UnivariateASH{T <: Real}(hist::Histogram{T, 1}, v::Vector{Float64}, m::Int, kernel::Symbol, n::Int)
    UnivariateASH{T}(hist, v, m, kernel, n)
end

function UnivariateASH(edg::AbstractVector, m::Int;
                       closed::Symbol = :right, bintype::Type = Int, kernel::Symbol = default_kernel)
    UnivariateASH(Histogram(edg, bintype, closed), zeros(length(edg) - 1), m, default_kernel, 0)
end

function UnivariateASH(a::Real, b::Real, nbin::Integer, m;
                       closed::Symbol = :right, bintype::Type = Int, kernel::Symbol = default_kernel)
    UnivariateASH(linrange(a, b, nbin), m,
                  closed = closed, bintype = bintype, kernel = kernel)
end


# Constructor with data (user provides endpoints and nbins)
function UnivariateASH(y::Vector, a::Real, b::Real, nbin::Int, m::Int;
                       closed::Symbol = :right, bintype::Type = Int, kernel::Symbol = default_kernel)
    o = UnivariateASH(a, b, nbin, m, closed = closed, bintype = bintype, kernel = kernel)
    update!(o, y)
    o
end
# Constructor with data (user provide edges)
function UnivariateASH(y::Vector, edg::AbstractVector, m::Int;
                       closed::Symbol = :right, bintype::Type = Int, kernel::Symbol = default_kernel)
    o = UnivariateASH(edge, m, closed = closed, bintype = bintype, kernel = kernel)
    update!(o, y)
    o
end

#-------------------------------------------------------------------------# fit
function fit(::Type{UnivariateASH}, y::Vector, w::WeightVec, edg::AbstractVector, m::Int;
             closed::Symbol = :right, kernel::Symbol = default_kernel)
    h = fit(Histogram, y, w, edg, closed = closed)
    o = UnivariateASH(h, zeros(length(edg) - 1), m, kernel, 0)
    update!(o, y)
    o
end

function fit(::Type{UnivariateASH}, y::Vector, edg::AbstractVector, m::Int;
             closed::Symbol = :right, kernel::Symbol = default_kernel)
    h = fit(Histogram, y, edg, closed = closed)
    o = UnivariateASH(h, zeros(length(edg) - 1), m, kernel, 0)
    update!(o, y)
    o
end

function fit(::Type{UnivariateASH}, y::Vector, a::Real, b::Real, nbin::Int, m::Int;
             closed::Symbol = :right, kernel::Symbol = default_kernel)
    fit(UnivariateASH, y, linrange(a, b, nbin), m, closed = closed, kernel = kernel)
end

#---------------------------------------------------------------------# update!
function update!(o::UnivariateASH, y::Real, ash::Bool = true)
    push!(o.hist, y)
    o.n += 1
    ash && ash!(o)
end

function update!{T <: Real}(o::UnivariateASH, y::Vector{T})
    for yi in y; update!(o, yi, false); end
    ash!(o)
end


#---------------------------------------------------------------------# Base
function Base.show(io::IO, o::UnivariateASH)
    println(io, typeof(o))
    println(io, "*  kernel: ", o.kernel)
    println(io, "*       m: ", o.m)
    println(io, "*   edges:", o.hist.edges[1])
end

Base.copy(o::UnivariateASH) = deepcopy(o)

function Base.merge!(o::UnivariateASH)
    # TODO
end

Base.merge(o::UnivariateASH) = merge!(copy(o))


#-----------------------------------------------------------# functions/methods
nout(o::UnivariateASH) = nobs(o) - sum(o.hist.weights)
nobs(o::UnivariateASH) = o.n
midpoints(o::UnivariateASH) = midpoints(o.hist.edges[1])

function mean(o::UnivariateASH)
    mean(midpoints(o), WeightVec(o.v))
end

function var(o::UnivariateASH)
    var(midpoints(o), WeightVec(o.v))
end

std(o::UnivariateASH) = sqrt(var(o))

function ash!(o::UnivariateASH, m::Int = o.m, kernel = o.kernel; warnout = true)
    o.m = m
    o.kernel = kernel
    nbins = length(o.hist.edges[1]) - 1
    @compat δ = Float64((o.hist.edges[1][2] - o.hist.edges[1][1]))
    for k = 1:nbins
        if o.hist.weights[k] != 0
            for i = maximum([1, k - o.m + 1]):minimum([nbins, k + o.m - 1])
                o.v[i] += o.hist.weights[k] * kernels[o.kernel]((i - k) / o.m)
            end
        end
    end

    o.v /= (sum(o.v) * δ)  # make y integrate to 1
    o.v[1] != 0 || o.v[end] != 0 && warn("nonzero density outside of bounds")
    return
end


# TESTING
if false
    h = fit(Histogram, randn(1000), -4:.1:4)
    x = randn(100_000)
    @time o = UnivariateASH(x, -4, 4, 1000, 5)
    @time o = fit(UnivariateASH, x, WeightVec(ones(length(x))), -4:.1:4, 5)
    @time o = fit(UnivariateASH, x, -4, 4, 100, 5)
    @time o = fit(UnivariateASH, x, -4:.01:4, 5)
    @time o = fit(UnivariateASH, x, linrange(-4, 4, 1000), 5)
    println("mean: ", mean(o) - mean(x))
    println(" var: ", var(o) - var(x))
    println(" std: ", std(o) - std(x))
    println("nobs: ", nobs(o))
end
