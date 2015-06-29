kernellist = [:uniform,
              :triangular,
              :epanechnikov,
              :biweight,
              :triweight,
              :tricube,
              :gaussian,
              :cosine,
              :logistic]

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

function UnivariateASH{T<:Real}(hist::Histogram{T, 1},
                          v::Vector{Float64},
                          m::Int,
                          kernel::Symbol,
                          n::Int)
    UnivariateASH{T}(hist, v, m, kernel, n)
end

# Univariate
function UnivariateASH{T <: Real}(edg::AbstractVector, ::Type{T}, closed::Symbol=:right)
    UnivariateASH(Histogram(edg, T, closed), zeros(length(edg) - 1), 1, :biweight, 0)
end

#---------------------------------------------------------------------# update!


#---------------------------------------------------------------------# Base
function Base.show(io::IO, o::UnivariateASH)
    println(io, typeof(o))
    println(io, "*  kernel: ", o.kernel)
    println(io, "*       m: ", o.m)
    println(io, "*   edges:", o.hist.edges[1])
end

#-----------------------------------------------------------# functions/methods
nout(o::UnivariateASH) = nobs(o) - sum(b.v)
nobs(o::UnivariateASH) = b.n
midpoints(o::UnivariateASH) = midpoints(o.hist.edges[1])


# TESTING
if true
    h = fit(Histogram, randn(1000), -4:.1:4)
    o = AverageShiftedHistograms.UnivariateASH([-4:.1:4], Int)
end
