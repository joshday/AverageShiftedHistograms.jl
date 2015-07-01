module BivariateTest
using AverageShiftedHistograms, StatsBase, FactCheck

facts("Bivariate") do
    context("Constructors") do
        p = length(-4:.1:4) - 1
        h = fit(Histogram, (randn(1000), randn(1000)), (-4:.1:4, -4:.1:4))
        o = BivariateASH(h, zeros(p, p), (5,10), (:uniform, :logistic), 0)
        copy(o)
        o = BivariateASH((1:10, 1:10), (5, 5))
        y = randn(100, 100)
        o = BivariateASH(y, (-4:.1:4, -4:.1:4), (5,5))
    end
    
    context("methods") do
        y = randn(100, 100)
        o = BivariateASH(y, (-4:.1:4, -4:.1:4), (5,5))
        show(o)
        nobs(o)
        midpoints(o)
    end
end

end # module
