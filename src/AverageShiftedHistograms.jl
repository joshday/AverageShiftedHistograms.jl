module AverageShiftedHistograms
    using Compat
    using Reexport
    @reexport using StatsBase
    using Docile
    @document

    import SmoothingKernels: kernels
    import Base: quantile, merge!, copy, mean, var, std, quantile, push!
    import TextPlots
    import StatsBase: fit, nobs, WeightVec
    import Grid

    export Bin1, Bin2, UnivariateASH, BivariateASH, ash, nout, update!, xy

    typealias VecF Vector{Float64}
    typealias MatF Matrix{Float64}
    typealias AVecF AbstractVector{Float64}
    typealias AMatF AbstractMatrix{Float64}

    const kernellist = [
        :uniform,
        :triangular,
        :epanechnikov,
        :biweight,
        :triweight,
        :tricube,
        :gaussian,
        :cosine,
        :logistic
        ]

    include("univariate.jl")
    # include("bivariate.jl")
end
