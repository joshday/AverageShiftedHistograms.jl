module AverageShiftedHistograms

import StatsBase
import Distributions
import UnicodePlots
using RecipesBase


export
    ash, fit!,
    # Kernels
    Kernels,
    biweight, cosine, epanechnikov, triangular, tricube, triweight, uniform,
    gaussian, logistic


# common
abstract AbstractAsh
StatsBase.nobs(o::AbstractAsh) = o.nobs
nout(o::AbstractAsh) = nobs(o) - sum(o.v)
function extendrange(y::AbstractVector, s = 0.5, n = 150)
    σ = std(y)
    linspace(minimum(y) - s * σ, maximum(y) + s * σ, n)
end

include("kernels.jl")
include("univariate.jl")
include("bivariate.jl")
end
