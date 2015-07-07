[![AverageShiftedHistograms](http://pkg.julialang.org/badges/AverageShiftedHistograms_release.svg)](http://pkg.julialang.org/?pkg=AverageShiftedHistograms&ver=release)
[![Build Status](https://travis-ci.org/joshday/AverageShiftedHistograms.jl.svg?branch=master)](https://travis-ci.org/joshday/AverageShiftedHistograms.jl)
[![Coverage Status](https://coveralls.io/repos/joshday/AverageShiftedHistograms.jl/badge.svg?branch=master)](https://coveralls.io/r/joshday/AverageShiftedHistograms.jl?branch=master)

# AverageShiftedHistograms

Density estimation using **Average Shifted Histograms**.  A summary of ASH is [here](http://www.stat.rice.edu/~scottdw/stat550/HW/hw4/c05.pdf).

## Installation:

```julia
Pkg.add("AverageShiftedHistograms")
```

This branch is a rewrite.  AverageShiftedHistograms will be (hopefully) faster and easier to use, but different from the version in Metadata.

## `UnivariateASH` Usage

```julia
using AverageShiftedHistograms, RDatasets
iris = dataset("datasets", "iris")
y = iris[:SepalLength].data

# the fit function can make an educated guess
o = fit(UnivariateASH, y)

# OR you can supply a Range (bin edges) and smoothing parameter
o = fit(UnivariateASH, y, 2:.1:10, 5)

# OR lower limit, upper limit, number of bins, and smoothing parameter
o = fit(UnivariateASH, y, 2, 10, 80, 5)
```

A sketch of the `UnivariateASH` estimate displays in the terminal thanks to [TextPlots](https://github.com/sunetos/TextPlots.jl).  You can get estimates of mean, variance, and standard deviation from the object.  WARNING:  `std()` estimates are highly influenced by oversmoothing.  
The estimate can be updated with new data via `update!(o, y)` and the smoothing parameter and kernel can be changed with `ash!(o, m, kernel)`

```julia
y = randn(100_000)

julia> o = fit(UnivariateASH, y, -5:.01:5, 2)
UnivariateASH
*  kernel: biweight
*       m: 2
*   nbins: 1000
*    nobs: 100000
 0.40000 ⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⢤
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠋⠀⠉⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡏⠀⠀⠀⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⠀⠀⠀⠐⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠇⠀⠀⠀⠀⠀⠹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠃⠀⠀⠀⠀⠀⠀⠀⠙⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⣠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⣀⣀⣀⣀⣀⣀⣠⡾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠳⣄⣀⣀⣀⣀⣀⣀⡀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
       0 ⠓⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠚
        -5                              5


julia> mean(o)
-0.0034575606229544312

julia> std(o)
1.0007091627478455

julia> update!(o, randn(10_000_000))

julia> ash!(o, 20, :gaussian)

julia> mean(o)
-0.0002740693968425348

julia> std(o)
1.0060198672102265

julia> o
UnivariateASH
*  kernel: gaussian
*       m: 20
*   nbins: 1000
*    nobs: 10100000
 0.40000 ⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⢤
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠉⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠁⠀⠈⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠇⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠀⠀⠀⠀⠀⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⠀⠀⠀⠸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠁⠀⠀⠀⠀⠀⠀⠀⠈⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⣀⣀⣀⣀⣀⣀⣠⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠲⣄⣀⣀⣀⣀⣀⣀⡀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
       0 ⠓⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠚
        -5                              5
```

## `BivariateASH` Usage
TODO

## Differences from `R`'s `ash`:
- TODO: timing comparison
- update estimate with new data: `update!(o, newdata)`
- Change smoothing parameter and kernel: `ash!(o, m [,kernel])`
- Get approximate mean/var from `UnivariateASH` with `mean(o)`, `var(o)`
- More kernel options provided by the [`SmoothingKernels`](https://github.com/johnmyleswhite/SmoothingKernels.jl) package
