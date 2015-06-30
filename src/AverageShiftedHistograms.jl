module AverageShiftedHistograms
    import Docile
    Docile.@document
    import SmoothingKernels: kernels
    import Base: quantile, merge, merge!, copy, mean, var, std
    import Compat: @compat
    import StatsBase:
        fit, nobs, Histogram, AbstractHistogram, midpoints, WeightVec

    export UnivariateASH, updatebatch!, fit, ash

    include("univariateash.jl")
end
