#=============================================================================#
# Bivariate Average Shifted Histograms
#
# This allows users to create an ASH estimate from a variety of contructors and
# fit methods.

# For smoothing parameters and kernels, argument is a Tuple:
# i.e., m = (3,5), kernel = (:biweight, :gaussian)
# Change the smoothing parameter `m` and `kernel` using ash!()
#=============================================================================#
#-------------------------------------------------------# type and constructors
type BivariateASH{T<:Real}
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
