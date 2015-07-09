[![AverageShiftedHistograms](http://pkg.julialang.org/badges/AverageShiftedHistograms_release.svg)](http://pkg.julialang.org/?pkg=AverageShiftedHistograms&ver=release)
[![Build Status](https://travis-ci.org/joshday/AverageShiftedHistograms.jl.svg?branch=master)](https://travis-ci.org/joshday/AverageShiftedHistograms.jl)
[![Coverage Status](https://coveralls.io/repos/joshday/AverageShiftedHistograms.jl/badge.svg?branch=master)](https://coveralls.io/r/joshday/AverageShiftedHistograms.jl?branch=master)

# AverageShiftedHistograms

Density estimation using **Average Shifted Histograms**.  A summary of ASH is [here](http://www.stat.rice.edu/~scottdw/stat550/HW/hw4/c05.pdf).

## Installation:

```julia
Pkg.clone("https://github.com/joshday/AverageShiftedHistograms.jl")
```
Note:  master is quite a bit different from the version in Metadata.

## [Docs](http://averageshiftedhistogramsjl.readthedocs.org)

## Differences from `R`'s `ash`:
- TODO: timing comparison
- update estimate with new data: `update!(o, newdata)`
- Change smoothing parameter and kernel: `ash!(o, m [,kernel])`
- Get approximate summary statistics from `UnivariateASH` with `mean(o)`, `var(o)`, `std(o)`, `quantile(o, tau)`
- More kernel options provided by the [`SmoothingKernels`](https://github.com/johnmyleswhite/SmoothingKernels.jl) package
