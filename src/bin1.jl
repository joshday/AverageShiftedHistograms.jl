#-------------------------------------------------------# type and constructors
type UnivariateASH{T <: Real, E} <: AbstractHistogram{T, 1, E}
    hist::Histogram{T, 1, E}  # Bins
    ash::Vector{Float64}              # ASH
    m::Int                            # Smoothing parameter
    kernel::Symbol                    # kernel
    n::Int                            # Number of observations
end

function UnivariateASH{T <: Real}(h::Histogram{T, 1}, ash, m, kernel, n)
        kernellist = [:uniform, :triangular, :epanechnikov, :biweight, :triweight, :tricube, :gaussian, :cosine, :logistic]
        kernel ∉ kernellist || error("kernel not recognized")
        m > 0 || error("Smoothing parameter m must be greater than 0")
        new(hist, ash, m, kernel, n)
    end

function UnivariateASH{T <: Real}(h::Histogram{T, 1}, m::Int, kernel::Symbol)
    UnivariateASH(h, zeros(length(h.edges) - 1), m, kernel, 0)
end

#---------------------------------------------------------------------# update!


#---------------------------------------------------------------------# Base
function Base.show(io::IO, o::UnivariateASH)
    println(io, "UnivariateASH")
end

#-----------------------------------------------------------# functions/methods
# nout(b::Bin1) = b.n - sum(b.v)
nobs(b::UnivariateASH) = b.n


# TESTING
if true
    h = fit(Histogram, randn(1000), -4:.1:4)
    o = UnivariateASH(h, 1, :biweight)
end
