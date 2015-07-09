# `UnivariateASH`


## Construction
There are two methods for creating a `UnivariateASH` object.

\* = keyword argument

### `ash(y::Vector{Float64}, rng::Range; m::Int = 5, kernel::Symbol = :biweight)`

| args       |  description  
|------------|--------------------------------------------------
| `y`        | data
| `rng`      | x values for which you want density estimate y = f(x)
| `m`\*      | number of adjacent bins to smooth over
| `kernel`\* | kernel used for smoothing

### `ash(y::Vector{Float64}; nbins::Int = 1000, r::Real = 0.2, m::Int = 5, kernel::Symbol = :biweight)`

| args       |  description  
|------------|--------------------------------------------------
| `y`        | data
| `nbins`\*  | number of bins to partition data into
| `r`\*      | extend extrema of data by r * (range of data)
| `m`\*      | number of adjacent bins to smooth over
| `kernel`\* | kernel used for smoothing



## Methods
A sketch of the `UnivariateASH` estimate displays in the terminal thanks to [TextPlots](https://github.com/sunetos/TextPlots.jl).  

The following methods are available for a `UnivariateASH` object:

- `nobs(o)`
- `nout(o)`
    - Number of observations that weren't caught in a histogram bin
- `mean(o)`
- `var(o)`
- `std(o)`
- `quantile(o, τ)`
- `pdf(o, x)`
    - return estimate of the density at `x`
- `xy(o)`
    - return `(x, y)` where `y` is the density estimate yᵢ = f(xᵢ)

WARNING:  `var()`, `std()`, and `quantile()` estimates are highly influenced by oversmoothing (be mindful of the `m` argument).  A little noise in the estimate is desirable.


```julia
julia> using AverageShiftedHistograms

julia> y = randn(1000);

julia> o = ash(y, -5:.1:5, m=5)
UnivariateASH
*  kernel: biweight
*       m: 5
*   edges: -5.0:0.1:5.0
*    nobs: 1000
 0.40000 ⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⢤
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠋⠙⠤⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠌⠀⠀⠀⠀⠀⢈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠂⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠅⠀⠀⠀⠀⠀⠀⠀⠘⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⢀⡴⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⣀⣀⣀⣀⣀⣀⡤⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠣⢄⣀⣀⣀⣀⣀⣀⡀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
       0 ⠓⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠚
        -5                              5


julia> mean(o)
0.0222

julia> var(o)
1.0502707243564355

julia> std(o)
1.0248271680417316

julia> quantile(o, 0.5)
-0.02811538852845198

julia> pdf(o, 0.0)
0.38336933693369335

julia> xy(o)
([-5.0,-4.9,-4.8,-4.7,-4.6,-4.5,-4.4,-4.3,-4.2,-4.1  …  4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0],[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0  …  0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0])
```

## Updating a `UnivariateASH` object

### `update!(o, y)`
- include new data and recompute the density

### `update!(o, m, kernel)`
- change the smoothing parameter and kernel

```julia
julia> y2 = randn(10_000);

julia> update!(o, y2)
UnivariateASH
*  kernel: biweight
*       m: 5
*   edges: -5.0:0.1:5.0
*    nobs: 11000
 0.40000 ⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⢤
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠎⠉⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠌⠀⠀⠈⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠁⠀⠀⠀⠐⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⢂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠅⠀⠀⠀⠀⠀⠐⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠌⠀⠀⠀⠀⠀⠀⠀⢐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⠁⠀⠀⠀⠀⠀⠀⠀⠀⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⣀⣀⣀⣀⣀⣀⡠⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠣⢄⣀⣀⣀⣀⣀⣀⡀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
       0 ⠓⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠚
        -5                              5


julia> update!(o, 4, :gaussian)

julia> o
UnivariateASH
*  kernel: gaussian
*       m: 4
*   edges: -5.0:0.1:5.0
*    nobs: 11000
 0.40000 ⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⢤
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠎⠉⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠌⠀⠀⠈⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠁⠀⠀⠀⠐⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⢂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠅⠀⠀⠀⠀⠀⠐⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠌⠀⠀⠀⠀⠀⠀⠀⢐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⠁⠀⠀⠀⠀⠀⠀⠀⠀⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
         ⡇⣀⣀⣀⣀⣀⣀⡠⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠣⢄⣀⣀⣀⣀⣀⣀⡀⢸
         ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
       0 ⠓⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠚
        -5                              5
```
