```@setup index
using Pkg
Pkg.add("Plots")
ENV["GKSwstype"] = "100"
ENV["GKS_ENCODING"]="utf8"
```

# AverageShiftedHistograms.jl


An Average Shifted Histogram (ASH) estimator is essentially a kernel density calculated
over a fine-partition histogram.

```@raw html
<img width = 600 src = "https://cloud.githubusercontent.com/assets/8075494/17938441/ce8815e4-69da-11e6-8f19-33052e2ef21e.gif">
```


## Usage

The main function exported by AverageShiftedHistograms is `ash`.

```@docs
ash
```

## Univariate Example

```@example index
using AverageShiftedHistograms
using Plots

y = randn(100_000)

o = ash(y; rng = -5:.5:5)

xy(o)  # return (rng, density)

plot(plot(o), plot(o; hist=false))
savefig("plot1.png")  # hide
```
![](plot1.png)


!!! warning
    Beware oversmoothing by setting the `m` parameter too large.  Note that "too large" is relative
    to the width of the bin edges.

```@example index
o = ash(y; rng = -5:.1:5, m = 20)
plot(o)
savefig("plot2.png")  # hide
```
![](plot2.png)


## Bivariate Example

```@example index
using AverageShiftedHistograms
using Plots

x = randn(10_000)
y = x + randn(10_000)

o = ash(x, y)

plot(o)
savefig("bivariate.png")  # hide
```

![](bivariate.png)

## Kernel Functions

Any nonnegative symmetric function can be provided to `ash` to be used as a kernel.  The function does not need to be normalized (integrate to 1) as the fitting procedure takes care of this.

```@docs
Kernels
```

```@eval index
plot([
    Kernels.biweight,    
    Kernels.cosine,      
    Kernels.epanechnikov,
    Kernels.triangular,  
    Kernels.tricube,     
    Kernels.triweight,   
    Kernels.uniform,     
    Kernels.gaussian,
    Kernels.logistic
], line=(2, :auto))

savefig("kernels.png")

nothing
```
![](kernels.png)
