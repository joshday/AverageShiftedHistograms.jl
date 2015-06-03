module AverageShiftedHistograms

    import SmoothingKernels: kernels
    import Distributions
    import Base: quantile, merge, merge!, copy, mean, var
    import StatsBase: mean, var, WeightVec
    import Gadfly: plot, Geom, layer, Theme
    import Compose: pt, color
    import Compat: @compat
    import OnlineStats: update!, updatebatch!
    import Distributions: cdf

    import Docile
    Docile.@document

    export
        Bin1, Bin2,
        Ash1, Ash2,
        extremastretch,
        merge, merge!, update!, updatebatch!

    include("bin1.jl")
    include("ash1.jl")
    include("bin2.jl")
    include("ash2.jl")
    include("summarystatistics.jl")
    include("plot.jl")

end

