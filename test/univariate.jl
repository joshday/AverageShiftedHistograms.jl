module UnivariateTest

using AverageShiftedHistograms, Distributions, FactCheck
a = AverageShiftedHistograms

facts("Univariate") do
    context("Bin1") do
        n = rand(10_000:100_000)
        y = randn(n)
        b1 = a.Bin1(-3, 3, 500)
        a.updatebatch!(b1, y)
        b2 = a.Bin1(n, hist(y, linspace(-3, 3, 501))...)
        b3 = a.Bin1(y, -3, 3, 500)

        @fact b1.v => b2.v
        @fact b2.v => b3.v
        @fact b3.v => hist(y, linspace(-3, 3, 501))[2]
    end

    context("Ash1") do
    end

    context("methods") do
        n = rand(10_000:100_000)
        y = randn(n)
        b1 = a.Bin1(-3, 3, 500)
        a.updatebatch!(b1, y)
        b2 = a.Bin1(n, hist(y, linspace(-3, 3, 501))...)
        b3 = a.Bin1(y, -3, 3, 500)
        @fact a.nobs(b1) => n
        @fact a.nobs(b2) => n
        @fact a.nobs(b3) => n

        b1 = a.Bin1(-3, 3, 500)
        updatebatch!(b1, [-4])
        @fact a.nobs(b1) => 1
        @fact a.nout(b1) => 1
        @fact sum(b1.v) => 0
    end
end

end # module
