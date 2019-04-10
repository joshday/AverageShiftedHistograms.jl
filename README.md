| Docs | Build | Test |
|------|-------|------|
| [![](https://img.shields.io/badge/docs-stable-blue.svg)](https://joshday.github.io/AverageShiftedHistograms.jl/stable) [![](https://img.shields.io/badge/docs-latest-blue.svg)](https://joshday.github.io/AverageShiftedHistograms.jl/latest) | [![Build Status](https://travis-ci.org/joshday/AverageShiftedHistograms.jl.svg?branch=master)](https://travis-ci.org/joshday/AverageShiftedHistograms.jl) [![Build status](https://ci.appveyor.com/api/projects/status/287rsp7u4qf0y3tw/branch/master?svg=true)](https://ci.appveyor.com/project/joshday/averageshiftedhistograms-jl/branch/master) | [![codecov.io](http://codecov.io/github/joshday/AverageShiftedHistograms.jl/coverage.svg?branch=master)](http://codecov.io/github/joshday/AverageShiftedHistograms.jl?branch=master)

# AverageShiftedHistograms

**Lightning fast density estimation in Julia.**

An Averaged Shifted Histogram (ASH) is essentially Kernel Density Estimation over a fine-partition histogram.  ASH only requires constant memory and can be constructed on-line, allowing you to estimate distributions for arbitrarily big data.

![](https://user-images.githubusercontent.com/8075494/54132735-20e89600-43eb-11e9-9915-c9d588f64308.gif)

## Quickstart:

```julia
import Pkg

Pkg.add("AverageShiftedHistograms")

using AverageShiftedHistograms

ash(randn(10^6))
```