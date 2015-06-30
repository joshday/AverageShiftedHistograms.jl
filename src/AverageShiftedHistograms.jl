module AverageShiftedHistograms
    import Docile
    Docile.@document
    import SmoothingKernels: kernels
    import Base: quantile, merge, merge!, copy, mean, var, std
    import Compat: @compat
    import StatsBase:
        fit, Histogram, AbstractHistogram, midpoints, WeightVec

    export UnivariateASH, updatebatch!, fit, ash, midpoints

    include("univariateash.jl")
end
