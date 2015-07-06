module BivariateTest
using AverageShiftedHistograms, FactCheck

facts("Bivariate") do
    context("Constructors") do
        o = Bin2(-4, 4, 50, -4, 4, 50)
        o = Bin2(-4:.1:4, -4:.1:4)

        n = rand(1000:10_000)
        x, y = randn(n), randn(n)

        o = Bin2(x, y, -4, 4, 50, -4, 4, 50)
        o = Bin2(x, y, -4:.1:4, -4:.1:4)
        h = hist2d([x y], -4:.1:4, -4:.1:4)
        @fact sum(h[3] - o.v) => 0 "Bin2 gives same result as hist2d"
    end

    context("methods") do
        println("nothing here")
    end
end

end # module
