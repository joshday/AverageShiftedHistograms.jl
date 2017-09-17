# AverageShiftedHistograms.jl


An Average Shifted Histogram (ASH) estimator is essentially a kernel density calculated
with a fine-partition histogram.


## Univariate Usage

The main function exported by AverageShiftedHistograms is `ash`.

```@docs
ash
```

## Univariate Toy Example
```julia
using AverageShiftedHistograms
using Plots; gr()

y = randn(100_000)

o = ash(y, -5:.1:5)

plot(o)
```
![](https://cloud.githubusercontent.com/assets/8075494/17912630/9267e1c0-6949-11e6-92d8-c2d93f96707b.png)


```julia
# BEWARE OVERSMOOTHING!
o = ash(y, -5:.1:5, m = 20)
plot(o)
```
![](https://cloud.githubusercontent.com/assets/8075494/17917468/bfd17c2a-6971-11e6-9ffd-93baee75f5a7.png)


## Kernel Functions

Any nonnegative symmetric function can be provided to `ash` to be used as a kernel.  The function does not need to be normalized (integrate to 1) as the fitting procedure takes care of this.

```@docs
Kernels
```


```@raw html
<img width = 700 src = "https://user-images.githubusercontent.com/8075494/30523575-acd48de2-9bb1-11e7-8f0f-3ce2ab09c713.png">
```
