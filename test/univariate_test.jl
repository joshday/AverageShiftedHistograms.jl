module UnivariateTest
using AverageShiftedHistograms, StatsBase, FactCheck

facts("Univariate") do
    context("Constructors") do
        n = rand(10_000:100_000)
        y = randn(n)
        o = UnivariateASH(y, -4, 4, 1000, 5)
        o = fit(UnivariateASH, y, WeightVec(ones(length(y))), -4:.1:4, 5)
        o = fit(UnivariateASH, y, -4, 4, 100, 5)
        o = fit(UnivariateASH, y, -4:.01:4, 5)
        o = fit(UnivariateASH, y, linrange(-4, 4, 1000), 5)
    end

end

end # module
