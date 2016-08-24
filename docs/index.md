# AverageShiftedHistograms.jl


An Average Shifted Histogram (ASH) estimator is essentially a kernel density calculated
with a fine-partition histogram.


---
## Univariate Usage

The main function exported by AverageShiftedHistograms is `ash`.

```julia
ash(x, rng = extendrange(x); m = 5, kernel = Kernels.biweight, warnout = true)
```
- `x`
    - Sample for which you want to calculate a density
- `rng = extendrange(x)`
    - Range of points to calculate the density at (partition of the histogram)
    - By default, uses `extendrange` to extend the maximum/minimum of the `x`
- `m = 5`
    - Smoothing parameter (number of adjacent bins to smooth over)
- `kernel = Kernels.biweight`
    - Smoothing kernel to use.  Kernels provided by AverageShiftedHistograms are within
    a `Kernels` module to help avoid potential name conflicts.  
    - Users can provide their own function to use.  The function should be strictly
     nonnegative, symmetric around 0, but not necessarily integrate to 1
        - `gaussian(u) = exp(-0.5 * u ^ 2)` (already in `Kernels`) is a valid kernel.
- `warnout = true`
    - print a warning if the estimated density is nonzero outside of `rng`

---
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

---
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
using Plots; gr()

x = randn(10_000)
y = x + randn(10_000)

o = ash(x, y)

plot(o)
```

![](https://cloud.githubusercontent.com/assets/8075494/17917649/3e36114c-6973-11e6-82e6-9a25d404547c.png)
