[![AverageShiftedHistograms](http://pkg.julialang.org/badges/AverageShiftedHistograms_release.svg)](http://pkg.julialang.org/?pkg=AverageShiftedHistograms&ver=release)
[![Build Status](https://travis-ci.org/joshday/AverageShiftedHistograms.jl.svg?branch=master)](https://travis-ci.org/joshday/AverageShiftedHistograms.jl)
[![Coverage Status](https://coveralls.io/repos/joshday/AverageShiftedHistograms.jl/badge.svg?branch=master)](https://coveralls.io/r/joshday/AverageShiftedHistograms.jl?branch=master)

# AverageShiftedHistograms

Density estimation using **Average Shifted Histograms**.  A great summary of ASH is [here](http://www.stat.rice.edu/~scottdw/stat550/HW/hw4/c05.pdf).

## Installation:

```julia
Pkg.add("AverageShiftedHistograms")
```

## Basic Usage
To anyone using this package, v0.2.0 will be a complete rewrite.  You'll have to relearn how to use it, but it'll be faster and easier (hopefully) to use!  Check the josh branch for a preview.


```julia
using AverageShiftedHistograms, RDatasets
iris = dataset("datasets", "iris")
y = iris[:SepalLength].data

# fit method takes arguments
#	- y::Vector (data)
#	- edg::AbstractVector (edges of histogram bins)
#	- m::Int (smoothing parameter)
o = fit(UnivariateASH, y, 2:.1:10, 5)
```


## Differences from `R`'s `ash`:
- TODO: timing comparison
- update estimate with new data: `update!(o, newdata)`
- Change smoothing parameter and kernel: `ash!(o, m [,kernel])`
- More kernel options provided by the [`SmoothingKernels`](https://github.com/johnmyleswhite/SmoothingKernels.jl) package
