
# Univariate Ash Estimator

This example looks at Sepal Length from the Iris dataset in
[RDatasets](https://github.com/johnmyleswhite/RDatasets.jl).

### General Usage:

1) create bins

2) create ash estimate from bins

3) view estimate with histogram

**Note**: For the same `Bin1` object, multiple `Ash1` objects can be made.  It may
be best to try several smoothing parameters `m` and kernels `kern` to find the
best fit.


### Load packages, iris data.
````julia
using AverageShiftedHistograms
using Gadfly
using RDatasets
using DataFrames

# Suppose we are interested in SepalLength.
# Make the datatype `Array`.  ASH doesn't use DataFrame (yet).
iris = dataset("datasets", "iris")
mydata = array(iris[1])  # Get SepalLength
````





### Make bins.  Make ash.

````julia
binSepalLength = Bin1(mydata, nbin = 40)  # create bins
ashSepalLength = Ash1(binSepalLength, m = 4, kern = :biweight)  # create ash
````





### Check fit.

````julia
plot(ashSepalLength, mydata)  # plot estimate over histogram
````





![](https://raw.githubusercontent.com/joshday/AverageShiftedHistograms.jl/master/doc/examples/figures/ash1_ex.png)
