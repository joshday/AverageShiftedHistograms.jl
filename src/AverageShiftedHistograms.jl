module AverageShiftedHistograms

    import SmoothingKernels, Distributions
    import Base: quantile
    using StatsBase
    using Gadfly
    using Docile


    include("bin1.jl")
    include("ash1.jl")
    include("bin2.jl")
    include("ash2.jl")
    include("plot.jl")
    include("summarystatistics.jl")
end

