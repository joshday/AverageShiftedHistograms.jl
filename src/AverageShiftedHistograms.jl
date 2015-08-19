module AverageShiftedHistograms
    using Compat
    using Reexport
    @reexport using StatsBase
    using Docile
    @document

    import Base: quantile, merge!, copy, mean, var, std, quantile, push!
    import StatsBase: fit, nobs, WeightVec
    import Distributions: pdf
    import UnicodePlots

    export Bin1, Bin2, UnivariateASH, BivariateASH, ash, nout, update!, xy, xyz

    typealias VecF Vector{Float64}
    typealias MatF Matrix{Float64}
    typealias AVecF AbstractVector{Float64}
    typealias AMatF AbstractMatrix{Float64}




    include("kernels.jl")
    include("univariate.jl")
    include("bivariate.jl")
end
