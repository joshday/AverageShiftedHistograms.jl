module AverageShiftedHistograms

    import SmoothingKernels
    using Gadfly
    using Docile


    include("bin1.jl")
    include("ash1.jl")
    include("bin2.jl")
    include("ash2.jl")
    include("plot.jl")
end

