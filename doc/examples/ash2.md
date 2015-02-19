
# Bivariate Ash Estimator

This example looks at Sepal Length/Width from the Iris dataset in
[RDatasets](https://github.com/johnmyleswhite/RDatasets.jl).

### General Usage:

1) create bins

2) create ash estimate from bins

3) view estimate

**Note**: For the same `Bin2` object, multiple `Ash2` objects can be made.  It may
be best to try several smoothing parameters `m1` / `m2` and kernels `k1` / `k2` to
find the best fit.


### Load packages, iris data.
````julia
using AverageShiftedHistograms
using Gadfly
using RDatasets
using DataFrames

# Suppose we are interested in SepalLength and SepalWidth.
# Make the datatype `Array`.  ASH doesn't use DataFrame (yet).
iris = dataset("datasets", "iris")
mydata = array(iris[1:2])  # Get SepalLength, SepalWidth
````







### Make bins.  Make ash.

````julia
bin = Bin2(mydata[:, 1], mydata[:, 2], nbin1 = 50, nbin2 = 50)  # create bins
ash = Ash2(bin, m1 = 3, m2 = 3, k1 = :biweight, k2 = :gaussian)
````







### Check fit.

````julia
plot(ash)  # plot estimate with histogram
````





![](https://raw.githubusercontent.com/joshday/AverageShiftedHistograms.jl/master/doc/examples/figures/ash2_ex.png)
