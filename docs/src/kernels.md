```@setup kernel
ENV["GKSwstype"] = "100"
ENV["GKS_ENCODING"]="utf8"
```

# Kernel Functions


A [kernel function](https://en.wikipedia.org/wiki/Kernel_(statistics)#Nonparametric_statistics) defines the smoothing behavior of the ASH estimator.  

**AverageShiftedHistograms** can use any function as a kernel that satisifies the following properties:

- Non-negative: `f(x) >= 0`
- Symmetric: `f(x) = f(-x)`

!!! note
    In most applications, kernels need to integrate to 1, but that is not required in **AverageShiftedHistograms**

## Function in `AverageShiftedHistograms.Kernels`

The **Kernels** module defines a collection of kernels:

- `biweight` (default)
- `cosine`
- `epanechnikov`
- `triangular`
- `tricube`
- `triweight`
- `uniform`
- `gaussian`
- `logistic`

See [https://en.wikipedia.org/wiki/Kernel_(statistics)#Kernel_functions_in_common_use](https://en.wikipedia.org/wiki/Kernel_(statistics)#Kernel_functions_in_common_use) for detailed descriptions.

```@eval kernel
kernels = [
        Kernels.biweight,    
        Kernels.cosine,      
        Kernels.epanechnikov,
        Kernels.triangular,  
        Kernels.tricube,     
        Kernels.triweight,   
        Kernels.uniform,     
        Kernels.gaussian,
        Kernels.logistic
    ]

plot(kernels, -1.5, 1.5, line=(2, :auto), lab=permutedims(string.(kernels)))

savefig("kernels.png")

nothing
```
![](kernels.png)
