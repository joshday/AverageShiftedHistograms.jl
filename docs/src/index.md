# AverageShiftedHistograms.jl


An Average Shifted Histogram (ASH) estimator is essentially a [kernel density estimator](https://en.wikipedia.org/wiki/Kernel_density_estimation) calculated over a fine-partition histogram.

## Benefits Over KDE

- The histogram component can be constructed on-line.
- Adding new data is an `O(nbins)` operation vs. `O(n)` for KDE, `nbins << n`.
- ASH is considerably faster even for small datasets.  See below with a comparison with [KernelDensity.jl](https://github.com/JuliaStats/KernelDensity.jl).

```julia
julia> @btime kde(x) setup=(x=randn(100));
  169.523 μs (106 allocations: 56.05 KiB)

julia> @btime ash(x) setup=(x=randn(100));
  4.173 μs (3 allocations: 8.22 KiB)
```


```@raw html
<img width = 600 src = "https://cloud.githubusercontent.com/assets/8075494/17938441/ce8815e4-69da-11e6-8f19-33052e2ef21e.gif">
```


## Usage

The main function exported by **AverageShiftedHistograms** is `ash`.

```@docs
ash
```


### Gotchas

!!! warning
    Beware oversmoothing by setting the `m` parameter too large.  Note that "too large" is relative
    to the width of the bin edges.

```@example
using AverageShiftedHistograms, Plots

y = randn(10 ^ 6)

o = ash(y; rng = -5:.1:5, m = 20)

plot(o)

savefig("indexplot.svg"); nothing # hide
```

![](indexplot.svg)
