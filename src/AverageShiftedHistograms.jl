module AverageShiftedHistograms

import StatsBase: nobs
import UnicodePlots
using RecipesBase


export
    ash, ash!, fit!, extendrange, xy, xyz, nout, nobs,
    # Kernels
    Kernels,
    biweight, cosine, epanechnikov, triangular, tricube, triweight, uniform,
    gaussian, logistic

const AVec = AbstractVector

abstract type AbstractAsh{N} end

#-----------------------------------------------------------------------# common
name(o) = replace(string(typeof(o)), "AverageShiftedHistograms.", "")
# StatsBase.nobs(o::AbstractAsh) = o.n
# nout(h::FastHistogram) =
# nout(o::AbstractAsh) = nobs(o) - sum(o.v)
# name(o) = replace(string(typeof(o)), "AverageShiftedHistograms.", "")
#
#
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
# include("bivariate.jl")
end
