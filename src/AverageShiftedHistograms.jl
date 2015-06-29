module AverageShiftedHistograms
    import Docile
    Docile.@document
    import SmoothingKernels: kernels
    import Base: quantile, merge, merge!, copy, mean, var
    import Compat: @compat
    import StatsBase: fit, Histogram, AbstractHistogram

    export UnivariateASH, updatebatch!, fit

    include("bin1.jl")
#     include("ash1.jl")
end
