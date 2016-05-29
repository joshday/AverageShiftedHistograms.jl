module ASHBenchmark

using AverageShiftedHistograms, BenchmarkTools
versioninfo()

# compile function
ash(randn(10), linspace(-4, 4, 100), m = 3)


x = randn(1_000_000)
@benchmark ash(x, linspace(-6, 6, 1000), m = 5)
end #module
