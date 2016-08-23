# AverageShiftedHistograms.jl


An Average Shifted Histogram (ASH) estimator is essentially a kernel density calculated
with a fine-partition histogram.


---
## Univariate Usage

The main function exported by AverageShiftedHistograms is `ash`.

```julia
ash(data, range = extendrange(data); m = 5, kernel = Kernels.biweight)
```
- `data`
    - Sample for which you want to calculate a density
- `range`
    - Range of points to calculate the density at (partition of the histogram)
    - By default, uses `extendrange` to extend the maximum/minimum of the `data`

```julia
function extendrange(y, s = 0.5, n = 150)
    σ = std(y)
    linspace(minimum(y) - s * σ, maximum(y) + s * σ, n)
end
```

- `m`
    - Smoothing parameter (number of adjacent bins to smooth over)
- `kernel`
    - Smoothing kernel to use.  Kernels provided by AverageShiftedHistograms are within
    a `Kernels` module to help avoid potential name conflicts.  
    - Users can provide their own function to use.  The function should be strictly
     nonnegative, symmetric around 0, but not necessarily integrate to 1
        - `gaussian(u) = exp(-0.5 * u ^ 2)` (already in `Kernels`) is a valid kernel.

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
