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

        y2 = randn(n)
        update!(o, y2)
        @fact nobs(o) => 2n
        o2 = copy(o)
        @fact nobs(o2) - nobs(o) => 0
        merge!(o, o2)
        @fact nobs(o) => 4n

        nout(o)
        mean(o)
        var(o)
        std(o)
        quantile(o, 0.5)
    end
end

end # module
