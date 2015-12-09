module BivariateTest
using AverageShiftedHistograms, FactCheck, StatsBase

facts("Bivariate") do
    context("Constructors") do
        n = rand(10_000:100_000)
        x = randn(n)
        y = sqrt(2)*randn(n) + 10
        o = ash(x, y, -4:.1:4, -5:.1:5)
        show(o)
    end

    context("methods") do
        n = rand(10_000:100_000)
        x = randn(n)
        y = sqrt(2)*randn(n) + 10
        o = ash(x, y)
        o = ash(x, y, -5:.1:5, 0:.1:20)
        @fact nobs(o) --> n
        fit!(o, x, y)
        @fact nobs(o) --> 2n
        ash!(o; mx = 2, my = 3, kernelx = :triweight, kernely = :logistic)
        @fact o.mx --> 2
        @fact o.my --> 3
        @fact o.kernelx --> :triweight
        @fact o.kernely --> :logistic
        xyz(o)
        @fact mean(o)[1] - mean(x) --> roughly(0.0, .01)
        @fact mean(o)[2] - mean(y) --> roughly(0.0, .01)
        @fact var(o)[1] - var(x) --> roughly(0.0, .1)
        @fact var(o)[2] - var(y) --> roughly(0.0, .1)
        @fact std(o)[1] - std(x) --> roughly(0.0, .1)
        @fact std(o)[2] - std(y) --> roughly(0.0, .1)

        o = ash(rand(100), rand(100))
        fit!(o, [-1.0], [-1.0])
        @fact nout(o) --> 1
    end
end

end # module
