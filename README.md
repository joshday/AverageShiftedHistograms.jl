[![Build Status](https://travis-ci.org/joshday/AverageShiftedHistogram.jl.svg?branch=master)](https://travis-ci.org/joshday/AverageShiftedHistogram.jl)
[![Coverage Status](https://coveralls.io/repos/joshday/AverageShiftedHistogram.jl/badge.svg?branch=master)](https://coveralls.io/r/joshday/AverageShiftedHistogram.jl?branch=master)

# AverageShiftedHistogram

Density estimation using **Average Shifted Histograms**.  A great summary of the ASH estimator is [here](http://www.stat.rice.edu/~scottdw/stat550/HW/hw4/c05.pdf).

## Read The Docs: [Documentation](http://ashjl.readthedocs.org/en/latest/)

## Basic Usage

Extremely similar to `R`'s [ash](http://cran.r-project.org/web/packages/ash/index.html) package.

```julia
using AverageShiftedHistogram
using Gadfly
using RDatasets
iris = dataset("datasets", "iris")

# AverageShiftedHistogram does not support DataFrames (currently)
sepal_length = array(iris[1])

# Create bins
b = Bin1(sepal_length, ab = [0, 10])

# create ASH estimate using bins, smoothing parameter 5, and Gaussian kernel
f = Ash1(b, 5, :gaussian)

# plot ASH estimate overlaid on histogram
plot(f, sepal_length)
```
