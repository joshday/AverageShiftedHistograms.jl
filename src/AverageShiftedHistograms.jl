module AverageShiftedHistograms
    using Compat
    using StatsBase
    import Docile
    Docile.@document

    import SmoothingKernels: kernels
    import Base: quantile, merge, merge!, copy, mean, var, std
    import TextPlots
    import StatsBase: fit, nobs, Histogram, AbstractHistogram, WeightVec, midpoints

    export UnivariateASH, BivariateASH, update!, ash!, value

    include("univariateash.jl")
    include("bivariateash.jl")
end
