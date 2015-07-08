module BivariateTest
using AverageShiftedHistograms, FactCheck

facts("Bivariate") do
    context("Constructors") do
        n = rand(10_000:100_000)
        x = randn(n)
        y = sqrt(2)*randn(n) + 10
        BivariateASH(x, y, -4:.1:4, -5:.1:5)
        ash(x, y, -4:.1:4, -5:.1:5)
        fit(BivariateASH, x, y, -4:.1:4, -5:.1:5)
    end

    context("methods") do
        n = rand(10_000:100_000)
        x = randn(n)
        y = sqrt(2)*randn(n) + 10
        o = AverageShiftedHistograms.BivariateASH(x, y, -4:.1:4, -4:.1:4)
        @fact nobs(o) => n
        update!(o, x, y)
        @fact nobs(o) => 2n
        xyz(o)
        mean(o)
    end
end

end # module
