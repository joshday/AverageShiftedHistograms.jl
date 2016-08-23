# AverageShiftedHistograms.jl


An Average Shifted Histogram (ASH) estimator is essentially a kernel density calculated
with a fine-partition histogram.



# Univariate

```julia
y = randn(100_000)

o = ash(y, -5:.1:5)

```
