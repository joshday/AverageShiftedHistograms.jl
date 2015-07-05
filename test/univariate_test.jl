module UnivariateTest
using AverageShiftedHistograms, FactCheck

facts("Univariate") do
    context("Constructors") do
        n = rand(10_000:100_000)
        y = randn(n)
        o = Bin1(-4, 4, 50)
        push!(o, y)
        o = Bin1(y, -4, 4, 100)
        o = Bin1(y, -4:.1:4)
        a = UnivariateASH(o, 3)
        a = UnivariateASH(o, 5, :gaussian, false)
        fit(UnivariateASH, y, -4:.1:4, 5)
    end

    context("methods") do
        n = rand(10_000:100_000)
        y = randn(n)
        o = fit(UnivariateASH, y, -4:.1:4, 5)
        @fact o.m => 5
        ash!(o, 3)
        @fact o.m => 3
        @fact o.kernel => :biweight
        ash!(o, 3, :triweight)
        @fact o.kernel => :triweight
        show(o)
        @fact nobs(o) => n
        nout(o)
        y2 = randn(n)
        update!(o, y2)
        @fact nobs(o) => 2 * n

        mean(o)
        var(o)
        std(o)
    end
end

end # module
