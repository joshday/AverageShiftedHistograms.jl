# `UnivariateASH`


## Construction
There are two methods for creating a `UnivariateASH` object.

\* = keyword argument

### `ash(y::VecF, rng::Range; m::Int = 5, kernel::Symbol = :biweight)`

| args       |  description  
|------------|--------------------------------------------------
| `y`        | data
| `rng`      | x values for which you want density estimate y = f(x)
| `m`\*      | number of adjacent bins to smooth over
| `kernel`\* | kernel used for smoothing

### `ash(y::VecF; nbins::Int = 1000, r::Real = 0.2, m::Int = 5, kernel::Symbol = :biweight)`

| args       |  description  
|------------|--------------------------------------------------
| `y`        | data
| `nbins`\*  | number of bins to partition data into
| `r`\*      | extend extrema of data by r * (range of data)
| `m`\*      | number of adjacent bins to smooth over
| `kernel`\* | kernel used for smoothing



## Summary Statistics
A sketch of the `UnivariateASH` estimate displays in the terminal thanks to [TextPlots](https://github.com/sunetos/TextPlots.jl).  You can get estimates of mean, variance, and standard deviation from the object.  WARNING:  `var()` and `std()` estimates are highly influenced by oversmoothing.  

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
```

## `update!()`

### `update!(o, y)`
- include new data and recompute the density

### `update!(o, m, kernel)`
- change the smoothing parameter and kernel
