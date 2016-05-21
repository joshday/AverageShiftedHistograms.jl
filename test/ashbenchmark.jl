module ASHBenchmark

using AverageShiftedHistograms, BenchmarkTools
versioninfo()

# compile function
fit(UnivariateASH, randn(10), linrange(-4, 4, 100), 3)


x = randn(1_000_000)
@benchmark o = fit(UnivariateASH, x, linrange(-6, 6, 1000), 5)
end #module
