# Bivariate Example


```@example
using AverageShiftedHistograms, Plots

x = randn(10_000)
y = x + randn(10_000)

o = ash(x, y)

plot(o)
```
