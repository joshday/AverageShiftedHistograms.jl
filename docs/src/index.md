# AverageShiftedHistograms.jl


An Average Shifted Histogram (ASH) estimator is essentially a kernel density calculated
with a fine-partition histogram.

```@raw html
<img width = 700 src = "https://cloud.githubusercontent.com/assets/8075494/17938441/ce8815e4-69da-11e6-8f19-33052e2ef21e.gif)">
```


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


## Bivariate Usage
```julia
ash(x, y; kw...)
ash(x, y, rngx, rngy; kw...)
```
- `x`, `y`
    - The bivariate data series (each is an AbstractVector)
- `rngx`, `rngy`
    - The histogram partition for `x` and `y`, respectively
- `kw...` Keyword arguments are
    - `mx = 5`, `my = 5`
        - Smoothing parameters for `x` and `y`
    - `kernelx = Kernels.biweight`, `kernely = Kernels.biweight`
        - Smoothing kernels for `x` and `y`
    - `warnout = true`
        - Print warning if density is nonzero on the edge of `rngx` or `rngy`


## Bivariate Toy Example
```julia
using AverageShiftedHistograms
using Plots; pyplot()

x = randn(10_000)
y = x + randn(10_000)

o = ash(x, y)

plot(o)
```

![](https://cloud.githubusercontent.com/assets/8075494/17917725/df56f456-6973-11e6-9347-abc82e262a82.png)

## Kernel Functions

Any nonnegative symmetric function can be provided to `ash` to be used as a kernel.  The function does not need to be normalized (integrate to 1) as the fitting procedure takes care of this.

```@docs
Kernels
```


![](https://user-images.githubusercontent.com/8075494/30523575-acd48de2-9bb1-11e7-8f0f-3ce2ab09c713.png)
