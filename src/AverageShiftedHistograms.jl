module AverageShiftedHistograms
    using Compat
    using Reexport
    @reexport using StatsBase
    import Docile
    Docile.@document

    import SmoothingKernels: kernels
    import Base: quantile, merge, merge!, copy, mean, var, std, quantile
    import TextPlots
    import StatsBase: fit, nobs, Histogram, AbstractHistogram, WeightVec, midpoints

    export UnivariateASH, BivariateASH, update!, updatebatch!, ash!, value

    include("univariateash.jl")
    include("bivariateash.jl")
end
