module UnivariateTest
using AverageShiftedHistograms, FactCheck, Grid

facts("Univariate") do
    context("Constructors") do
        n = rand(10_000:100_000)
        y = randn(n)

        o = fit(UnivariateASH, y, -4:.1:4)
        o = UnivariateASH(y, -4:.1:4)
        o = ash(y, -4:.1:4, m = 3, kernel = :gaussian)
    end

    context("methods") do
        n = rand(10_000:100_000)
        y = randn(n)
        o = AverageShiftedHistograms.UnivariateASH(y, -4:.1:4, m=3)
        o = ash(y, -4:.1:4)
        show(o)
        @fact mean(o) - mean(y) => roughly(0.0, .1)
        @fact var(o)  - var(y) => roughly(0.0, .1)
        @fact std(o)  - std(y) => roughly(0.0, .1)
        @fact quantile(o, 0.5)  - quantile(y, 0.5) => roughly(0.0, .3)
        @fact typeof(xy(o)) <: Tuple => true
        @fact xy(o)[1] => [-4:.1:4]
        @fact maxabs(o.v - hist(y, (-4:.1:4.1) - .05)[2]) => 0 "Check that histogram is correct"
        pdf(o, 0.0)

        @fact nobs(o) => n

        y2 = randn(n)
        update!(o, y2)
        @fact nobs(o) => 2n
        o2 = copy(o)
        @fact nobs(o2) - nobs(o) => 0
        merge!(o, o2)
        @fact nobs(o) => 4n

        o = ash(rand(10), -1:.1:1)
        @fact nout(o) => 0
        update!(o, [5.0])
        @fact nout(o) => 1

        grid = CoordInterpGrid(o)
    end
end

end # module
