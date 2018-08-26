module AverageShiftedHistograms

import UnicodePlots, RecipesBase
using LinearAlgebra, Statistics
import StatsBase: nobs, fweights
export ash, ash!, extendrange, xy, xyz, nout, nobs, Kernels


#-----------------------------------------------------------------------# common

"""
`extendrange(x, s = .5, n = 200)`

Create a range of length `n` starting at `s` standard deviations below
`minimum(x)` and ending at `s` standard deviations above `maximum(x)`
"""
function extendrange(y::AbstractVector, s = 0.5, n = 500)
    σ = std(y)
    range(minimum(y) - s * σ, stop = maximum(y) + s * σ, length = n)
end

include("kernels.jl")
include("univariate.jl")
include("bivariate.jl")
end
