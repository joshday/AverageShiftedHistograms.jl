[![AverageShiftedHistograms](http://pkg.julialang.org/badges/AverageShiftedHistograms_0.6.svg)](http://pkg.julialang.org/detail/AverageShiftedHistograms)
[![Build Status](https://travis-ci.org/joshday/AverageShiftedHistograms.jl.svg?branch=master)](https://travis-ci.org/joshday/AverageShiftedHistograms.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/287rsp7u4qf0y3tw/branch/master?svg=true)](https://ci.appveyor.com/project/joshday/averageshiftedhistograms-jl/branch/master)
[![codecov.io](http://codecov.io/github/joshday/AverageShiftedHistograms.jl/coverage.svg?branch=master)](http://codecov.io/github/joshday/AverageShiftedHistograms.jl?branch=master)

### Documentation
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://joshday.github.io/AverageShiftedHistograms.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://joshday.github.io/AverageShiftedHistograms.jl/latest)

# AverageShiftedHistograms

Density estimation using Average Shifted Histograms.  ASH is essentially Kernel Density Estimation using a fine-partition histogram.  ASH requires O(1) storage and can be used on datasets larger than computer memory.

![](https://cloud.githubusercontent.com/assets/8075494/17938441/ce8815e4-69da-11e6-8f19-33052e2ef21e.gif)

## Installation:

```julia
Pkg.add("AverageShiftedHistograms")
```
