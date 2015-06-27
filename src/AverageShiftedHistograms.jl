module AverageShiftedHistograms
    import Docile
    Docile.@document
    import SmoothingKernels: kernels
    import Base: quantile, merge, merge!, copy, mean, var
    import Compat: @compat

    export Bin1, Ash1, updatebatch!

    include("bin1.jl")
    include("ash1.jl")

end
