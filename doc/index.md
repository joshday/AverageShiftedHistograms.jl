
# Average Shifted Histograms Density Estimation

## Usage


This example generates bins from some `myUnivariateDataset` using 50 bins.  The default range of the bins extends the range of the data by 10%.  A Gaussian kernel is then used to make the ASH estimator with smoothing parameter $m=5$.

```julia
using AverageShiftedHistogram
using Gadfly

bins = Bin1(myUnivariateDataset, nbin=50)
ash = Ash1(bins, 5, :gaussian)

plot(ash)
```

## Types
- `Bin1`, `Bin2`
	- Stores necessary information about bin locations and counts for univarite and bivariate data, respectively
- `Ash1`, `Ash2`
	- Stores the ASH estimate generated from a `Bin1`, `Bin2` object , respectively

## Examples
[examples folder on GitHub](https://github.com/joshday/AverageShiftedHistogram.jl/tree/master/doc/examples)