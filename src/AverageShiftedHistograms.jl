module AverageShiftedHistograms
    import Base: quantile, merge!, copy, mean, var, std, quantile, push!
    import StatsBase
    import Distributions
    import UnicodePlots
    import OnlineStats

    export Bin1, Bin2, UnivariateASH, BivariateASH,
    ash, ash!, nout, update!, xy, xyz

    typealias VecF Vector{Float64}
    typealias MatF Matrix{Float64}
    typealias AVecF AbstractVector{Float64}
    typealias AMatF AbstractMatrix{Float64}

    abstract ASH

    include("kernels.jl")
    include("univariate.jl")
    include("bivariate.jl")

    using Requires
    @require Plots include("plot.jl")
end
