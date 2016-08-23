module AverageShiftedHistograms
import StatsBase
import Distributions
import UnicodePlots

export
    ash, fit!,
    # Kernels
    Kernels,
    biweight, cosine, epanechnikov, triangular, tricube, triweight, uniform,
    gaussian, logistic

include("kernels.jl")
include("univariate.jl")
# include("bivariate.jl")
# include("plots.jl")
end
