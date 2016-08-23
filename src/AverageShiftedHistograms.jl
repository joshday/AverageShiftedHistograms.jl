module AverageShiftedHistograms
import StatsBase
import Distributions
import UnicodePlots

export
    ash,
    #kernels
    biweight, cosine, epanechnikov, triangular, tricube, triweight, uniform,
    gaussian, logistic,
    # ASH
    UnivariateASH

include("kernels.jl")
include("univariate.jl")
# include("bivariate.jl")
# include("plots.jl")
end
