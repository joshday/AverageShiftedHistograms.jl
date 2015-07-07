module UnivariateTest
using AverageShiftedHistograms, FactCheck

facts("Univariate") do
    context("Constructors") do
        n = rand(10_000:100_000)
        y = randn(n)

        o = UnivariateASH(y, -4:.1:4)
    end

    context("methods") do
        n = rand(10_000:100_000)
        y = randn(n)
        o = UnivariateASH(y, -4:.1:4)
        o = ash(y, -4:.1:4)
        show(o)

        @fact nobs(o) => n
    end
end

end # module
