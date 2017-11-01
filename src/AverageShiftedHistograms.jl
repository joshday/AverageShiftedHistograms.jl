module AverageShiftedHistograms

import UnicodePlots, Distributions, RecipesBase
import StatsBase: nobs, fweights
using Distributions: pdf, cdf
export ash, ash!, extendrange, xy, xyz, nout, nobs, pdf, cdf, Kernels


#-----------------------------------------------------------------------# common

"""
`extendrange(x, s = .5, n = 200)`

Create a `LinSpace` of length `n` starting at `s` standard deviations below
`minimum(x)` and ending at `s` standard deviations above `maximum(x)`
"""
function extendrange(y::AbstractVector, s = 0.5, n = 200)
    σ = std(y)
    linspace(minimum(y) - s * σ, maximum(y) + s * σ, n)
end

include("kernels.jl")
include("univariate.jl")
include("bivariate.jl")
end
