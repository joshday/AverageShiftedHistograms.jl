module AverageShiftedHistograms

    import SmoothingKernels, Distributions
    import Base: quantile
    import StatsBase: mean, var
    import Gadfly: plot, Geom, layer, Theme
    import Compose: pt, color
    import Compat: @compat

    import Docile
    Docile.@document

    export
        Bin1,
        Bin2,
        Ash1,
        Ash2,
        extremastretch



    include("bin1.jl")
    include("ash1.jl")
#     include("bin2.jl")
#     include("ash2.jl")
    include("plot.jl")
#     include("summarystatistics.jl")
end

