module UnivariateTest
using AverageShiftedHistograms, StatsBase, FactCheck

facts("Univariate") do
    context("Constructors") do
        n = rand(10_000:100_000)
        y = randn(n)
        h = fit(Histogram, y, -4:.1:4)
        o = UnivariateASH{Int}(h, zeros(length(-4:.1:4) - 1), 5, :triangular, 0)
        o = UnivariateASH(h, zeros(length(-4:.1:4) - 1), 5, :biweight, 0)
        o = UnivariateASH(y, -4, 4, 1000, 5, bintype = Float64, closed = :left)
        o = UnivariateASH(y, -4, 4, 1000, 5, kernel = :gaussian, bintype = Float64, closed = :left)
        o = UnivariateASH(y, -4:.1:4, 5, kernel = :triangular, closed = :right)
        o = fit(UnivariateASH, y, WeightVec(ones(length(y))), -4:.1:4, 5)
        o = fit(UnivariateASH, y, -4, 4, 100, 5)
        o = fit(UnivariateASH, y, -4:.01:4, 5)
        o = fit(UnivariateASH, y, linrange(-4, 4, 1000), 5)
        ash!(o, 10)
        @fact o.m => 10
        show(o)
        copy(o)
        merge!(o)
        merge(o)
        @fact midpoints(o) => midpoints(o.hist.edges[1])
        @fact mean(o) => roughly(mean(y), .01)
        @fact var(o) => roughly(var(y), .01)
        @fact std(o) => roughly(std(y), .01)
        @fact nobs(o) => n
    end
end

end # module
