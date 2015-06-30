module AverageShiftedHistograms
    import Docile
    Docile.@document
    import SmoothingKernels: kernels
    import Base: quantile, merge, merge!, copy, mean, var, std
    import Compat: @compat
    import StatsBase:
        fit, nobs, Histogram, AbstractHistogram, WeightVec, midpoints

    export UnivariateASH, updatebatch!, fit, ash!, midpoints, loadvis

    include("univariateash.jl")


    # Hack to avoid loading Gadfly each time (adopted from Sigma.jl)
    function loadvis(package::Symbol = :Gadfly)
        gadflypath = Pkg.dir("AverageShiftedHistograms", "src", "gadflymethods.jl")
        package == :Gadfly && include(gadflypath)
        # TODO: Add methods for other plotting packages
    end

end
