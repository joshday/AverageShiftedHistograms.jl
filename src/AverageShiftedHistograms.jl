module AverageShiftedHistograms
    import Docile
    Docile.@document
    import SmoothingKernels: kernels
    import Base: quantile, merge, merge!, copy, mean, var, std
    import Compat: @compat
    import StatsBase:
        fit, nobs, Histogram, AbstractHistogram, WeightVec, midpoints

    export UnivariateASH, updatebatch!, fit, ash!, midpoints, loadvis

    include("univariateash.jl")
    include("bivariateash.jl")
end
