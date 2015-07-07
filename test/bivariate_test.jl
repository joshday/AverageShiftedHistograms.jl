module BivariateTest
using AverageShiftedHistograms, FactCheck

facts("Bivariate") do
    context("Constructors") do
        n = rand(10_000:100_000)
        x = randn(n)
        y = randn(n)
        BivariateASH(x, y, -4:.1:4, -5:.1:5)
        ash(x, y, -4:.1:4, -5:.1:5)
        fit(BivariateASH, x, y, -4:.1:4, -5:.1:5)
    end

    context("methods") do
        n = rand(10_000:100_000)
        x = randn(n)
        y = randn(n)
        o = AverageShiftedHistograms.BivariateASH(x, y, -4:.1:4, -4:.1:4)
        @fact nobs(o) => n
        xyz(o)
    end
end

end # module
