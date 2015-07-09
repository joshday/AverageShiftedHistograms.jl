# `BivariateASH`


## Construction
There are two methods for creating a `BivariateASH` object.

### `ash(x::Vector{Float64}, y::Vector{Float64}, rngx::Range, rngy::Range; mx::Int = 5, my::Int = 5, kernelx::Symbol = :biweight, kernely::Symbol = :biweight)`

### `ash(x::Vector{Float64}, y::Vector{Float64}; nbinx::Int = 1000, nbiny::Int = 1000, r::Real = 0.2, mx = 5, my = 5, kernelx = :biweight, kernely = :biweight)`


## Methods
- `nobs(o)`
- `nout(o)`
    - Number of observations that weren't caught in a histogram bin
- `mean(o)`
- `var(o)`
- `std(o)`
- `xyz(o)`
    - return `(x, y, z)` where `x` and `y` are vectors and `z` is matrix of density values where
    `f(y[i], x[j]) = z[i, j]`


## Updating a `BivariateASH` object

### `update!(o, x, y)`
- include new data and recompute the density

### `update!(o, mx, my, kernelx, kernely)`
- change the smoothing parameters and kernels
