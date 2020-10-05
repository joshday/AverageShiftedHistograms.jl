# Univariate Example

```@example
using AverageShiftedHistograms, Plots

y = randn(100_000)

o = ash(y; rng = -5:.2:5)

xy(o)  # return (rng, density)

plot(plot(o), plot(o; hist=false), layout=(2,1))
```