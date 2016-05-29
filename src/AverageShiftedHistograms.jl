module AverageShiftedHistograms
    import StatsBase
    import StatsBase: nobs, fit!, fit
    import Distributions
    import Distributions: pdf
    import UnicodePlots

    export Bin1, Bin2, UnivariateASH, BivariateASH,
    ash, ash!, nout, xy, xyz, fit!, nobs, pdf, fit

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
