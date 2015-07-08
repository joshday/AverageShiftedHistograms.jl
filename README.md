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
using AverageShiftedHistograms
y = randn(10_000)

# the following are equivalent
# Each fits an average shifted histogram at the points in the range
# -5:.1:5 using smoothing parameter m=5 and a gaussian kernel
o = fit(UnivariateASH, y, -5:.1:5, m = 5, kernel = :gaussian)
o = ash(y, -5:.1:5, m = 5, kernel = :gaussian)
o = UnivariateASH(y, -5:.1:5, m = 5, kernel = :gaussian)
```

A sketch of the `UnivariateASH` estimate displays in the terminal thanks to [TextPlots](https://github.com/sunetos/TextPlots.jl).  You can get estimates of mean, variance, and standard deviation from the object.  WARNING:  `std()` estimates are highly influenced by oversmoothing.  
The estimate can be updated with new data via `update!(o, y)` and the smoothing parameter and kernel can be changed with `update!(o, m, kernel)`

```julia
julia> y = randn(10_000);

julia> o = ash(y, -5:.1:5, m=3)
UnivariateASH
*  kernel: biweight
*       m: 3
*   edges: -5.0:0.1:5.0
*    nobs: 10000
 0.40000 ⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⢤
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡊⠉⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠔⠀⠀⠈⢂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠁⠀⠀⠀⠐⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡈⠀⠀⠀⠀⠀⢂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠐⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠌⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⠁⠀⠀⠀⠀⠀⠀⠀⠀⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⣀⣀⣀⣀⣀⣀⡠⠒⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠢⢄⣀⣀⣀⣀⣀⣀⡀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
       0 ⠓⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠚
        -5                              5


julia> mean(o)
-0.01945000000000003

julia> var(o)
1.0197147901640933

julia> std(o)
1.0098092840552086

julia> update!(o, randn(10_000))
UnivariateASH
*  kernel: biweight
*       m: 3
*   edges: -5.0:0.1:5.0
*    nobs: 20000
 0.40000 ⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⢤
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠌⠙⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠁⠀⠘⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠁⠀⠀⠀⠨⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⢅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠅⠀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡐⠀⠀⠀⠀⠀⠀⠀⠡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠁⠀⠀⠀⠀⠀⠀⠀⠈⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⢠⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⣀⣀⣀⣀⣀⣀⡠⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⢄⣀⣀⣀⣀⣀⣀⡀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
       0 ⠓⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠚
        -5                              5


julia> update!(o, 10, :gaussian)

julia> o
UnivariateASH
*  kernel: gaussian
*       m: 10
*   edges: -5.0:0.1:5.0
*    nobs: 20000
 0.40000 ⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⢤
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠎⠉⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡊⠀⠀⠀⠡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⠀⠀⠀⠀⠈⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡁⠀⠀⠀⠀⠀⢐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡐⠀⠀⠀⠀⠀⠀⠀⢂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠁⠀⠀⠀⠀⠀⠀⠀⠐⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⢀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⢀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⣀⣀⣀⣀⣀⣠⠔⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠦⣀⣀⣀⣀⣀⣀⡀⢸
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
