
using AverageShiftedHistograms
versioninfo()

# compile function
fit(UnivariateASH, randn(10), linrange(-4, 4, 100), 3)


x = randn(10_000_000)
@time o = fit(UnivariateASH, x, linrange(-6, 6, 1000), 5)
