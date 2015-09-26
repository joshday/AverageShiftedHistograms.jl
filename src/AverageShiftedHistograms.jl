"Univariate and bivariate average shifted histograms for large-scale density estimation"
module AverageShiftedHistograms


    import Base: quantile, merge!, copy, mean, var, std, quantile, push!
    import StatsBase
    import Distributions
    import UnicodePlots
    import Plots

    export Bin1, Bin2, UnivariateASH, BivariateASH,
    ash, ash!, nout, update!, xy, xyz

    using Reexport
    @reexport using StatsBase
    @reexport using Plots
    @reexport using Distributions

    typealias VecF Vector{Float64}
    typealias MatF Matrix{Float64}
    typealias AVecF AbstractVector{Float64}
    typealias AMatF AbstractMatrix{Float64}

    abstract ASH

    include("kernels.jl")
    include("univariate.jl")
    include("bivariate.jl")
    include("plot.jl")
end
