module UnivariateTest
using AverageShiftedHistograms, FactCheck

facts("Univariate") do
    context("Constructors") do
        o = Bin1(-4, 4, 100)
        for i in 1:10
            n = rand(10_000:100_000)
            y = randn(n)
            o = Bin1(-4, 4, 50)
            update!(o, y)
            o = Bin1(y, -4, 4, 100)
            o = Bin1(y, -4:.1:4)
            a = UnivariateASH(o, 3)
            a = UnivariateASH(o, 5, :gaussian, false)
            fit(UnivariateASH, y, -4:.1:4, 5)
            fit(UnivariateASH, y, -4, 4, 100, 5)
            fit(UnivariateASH, y)
            fit(UnivariateASH, y, nbin = 1001)
        end
    end

    context("methods") do
        n = rand(10_000:100_000)
        y = randn(n)
        o = fit(UnivariateASH, y, -4, 4, 100, 5)
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

        @fact mean(o) => roughly(mean([y; y2]), .001)
        @fact midpoints(o) => o.x
        @fact var(o) => roughly(var([y; y2]), .1)
        @fact std(o) => roughly(std([y; y2]), .1)
        o2 = copy(o)
        @fact o.x => o2.x
        @fact o.y => o2.y
        o2 = fit(UnivariateASH, y, -4:.1:4, 5)
        merge!(o, o2)
        update!(o, y)
        @fact quantile(o, 0.5) => roughly(quantile(y, .5), .1)
    end
end

end # module
