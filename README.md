[![AverageShiftedHistograms](http://pkg.julialang.org/badges/AverageShiftedHistograms_release.svg)](http://pkg.julialang.org/?pkg=AverageShiftedHistograms&ver=release)
[![Build Status](https://travis-ci.org/joshday/AverageShiftedHistograms.jl.svg?branch=master)](https://travis-ci.org/joshday/AverageShiftedHistograms.jl)
[![Coverage Status](https://coveralls.io/repos/joshday/AverageShiftedHistograms.jl/badge.svg?branch=master)](https://coveralls.io/r/joshday/AverageShiftedHistograms.jl?branch=master)
[![codecov.io](http://codecov.io/github/joshday/AverageShiftedHistograms.jl/coverage.svg?branch=master)](http://codecov.io/github/joshday/AverageShiftedHistograms.jl?branch=master)

# AverageShiftedHistograms

Density estimation using [Average Shifted Histograms](http://www.stat.rice.edu/~scottdw/stat550/HW/hw4/c05.pdf).

## Installation:

```julia
Pkg.add("AverageShiftedHistograms")
```

## Differences from `R`'s `ash`:
- TODO: timing comparison
- update estimate with new data: `update!(o, newdata)`
- Change smoothing parameter and kernel: `ash!(o, m [,kernel])`
- Get approximate summary statistics from `UnivariateASH` with `mean(o)`, `var(o)`, `std(o)`, `quantile(o, tau)`
- More kernel options

## Usage

#### Univariate
```julia
o = ash(randn(1000), nbins = 1000)  # 1000 bins by default
o = ash(randn(1000), -4:.1:4)
update!(o, 10, :gaussian)  # change smoothing parameter to 10 and kernel to gaussian
update!(o, randn(123))  # include more data

# Get approximate estimates
mean(o)
var(o)
std(o)
quantile(o, .5)
quantile(o, [.25, .5, .75])
pdf(o, 0.0)
nobs(o)  # number of observations in the estimate
nout(o)  # number of observations that fell outside of bins

# Get x and y (density) values
xy(o)
```


#### Bivariate
```julia
x, y = randn(1000), randn(1000) + 3

o = ash(x, y)

# change smoothing parameter for x to 5
# change smoothing parameter for y to 10
# change kernel to x to guassian
# change kernel for y to triweight
update!(o, 5, 10, :gaussian, :triweight)

# include more data
x2, y2 = randn(123), randn(123) + 3
update!(o, x2, y2)

# Get approximate estimates
nobs(o)
nout(o)
mean(o)
var(o)
std(o)

# get x, y, and z (density) values
xyz(o)
```
