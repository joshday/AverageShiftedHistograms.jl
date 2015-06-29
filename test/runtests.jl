using AverageShiftedHistograms
using Base.Test

include("univariate.jl")
include("bivariate.jl")

FactCheck.exitstatus()
