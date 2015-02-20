[![Build Status](https://travis-ci.org/joshday/AverageShiftedHistograms.jl.svg?branch=master)](https://travis-ci.org/joshday/AverageShiftedHistograms.jl)
[![Coverage Status](https://coveralls.io/repos/joshday/AverageShiftedHistograms.jl/badge.svg?branch=master)](https://coveralls.io/r/joshday/AverageShiftedHistograms.jl?branch=master)

# AverageShiftedHistograms

Density estimation using **Average Shifted Histograms**.  A great summary of ASH is [here](http://www.stat.rice.edu/~scottdw/stat550/HW/hw4/c05.pdf).

## Installation:

From Julia REPL:

```julia
Pkg.add("AverageShiftedHistograms")
```

## Read The Docs: [Documentation](http://averageshiftedhistogramsjl.readthedocs.org)

## Basic Usage

Extremely similar to `R`'s [ash](http://cran.r-project.org/web/packages/ash/index.html) package.

```julia
using AverageShiftedHistograms
using Gadfly
using RDatasets
iris = dataset("datasets", "iris")

# AverageShiftedHistograms does not support DataFrames (currently)
sepal_length = array(iris[1])

b = Bin1(sepal_length)
f = Ash1(b)
Gadfly.plot(f, sepal_length)
```
![](doc/examples/figures/READMEplot.png)
