#---------------------------------------------------------------------# UnivariateASH
type UnivariateASH
    rng::FloatRange{Float64}    # x values for which you want to find density y = f(x)
    v::Vector{Int}              # Counts in each bin
    y::VecF                     # density y = f(x)
    m::Int                      # smoothing parameter
    kernel::Symbol              # kernel
    n::Int                      # number of observations
    function UnivariateASH(rng::FloatRange{Float64}, m::Int = 5, kernel::Symbol = :biweight)
        l = length(rng)
        l >= 2 || error("need at least 2 bins!")
        m >= 0 || error("smoothing parameter must be nonnegative")
        kernel in kernellist || error("kernel not recognized")
        new(rng, zeros(Int, l), zeros(l), m, kernel, 0.0)
    end
end

"""
Create a UnivariateASH or BivariateASH object from data.

### UnivariateASH

    ash(y, rng; m = 5, kernel = :biweight)
    ash(y; nbins = 1000, r = 0.2, ...)

Calculate the density at each element in `rng` using smoothing parameter `m` and
kernel `kernel`.  Alternatively, supply the number of histogram bins `nbins` and
a multiplier `r` to determine endpoints.  Endpoints extend the extrema of `y` by
`r` times its range: `r * (maximum(y) - minimum(y))`.


### BivariateASH

    ash(x, y, rngx, rngy; mx = 5, my = 5, kernelx = :biweight, kernely = :biweight)
    ash(x, y; nbinx = 1000, nbiny = 1000, r = 0.2, ...)

Arguments work similarly to their univariate equivalents.
"""
function ash(y::VecF, rng::Range; m::Int = 5, kernel::Symbol = :biweight)
    @compat myrng = FloatRange(Float64(rng.start), Float64(rng.step), Float64(rng.len), Float64(rng.divisor))
    o = UnivariateASH(rng, m, kernel)
    updatebin!(o, y)
    update!(o)
    o
end

function ash(y::VecF; nbins::Int = 1000, r::Real = 0.2, m::Int = 5, kernel::Symbol = :biweight)
    r > 0 || error("r must be positive")
    a, b = extrema(y)
    rng = b - a
    a -= r * rng
    b += r * rng
    step = (b - a) / nbins
    ash(y, a:step:b, m = m, kernel = kernel)
end


function updatebin!(o::UnivariateASH, y::Vector{Float64})
    δ = o.rng.step / o.rng.divisor
    a = o.rng[1]
    nbin = length(o.rng)
    o.n += length(y)
    for yi in y
        # This line below is different from the paper because the input to UnivariateASH
        # is the points where you want the estimate and not the bin edges.
        ki::Int = floor(Int, (yi - a) / δ + 1.5)
        if 1 <= ki <= nbin
            o.v[ki] += 1
        end
    end
    nothing
end


"""
Update a UnivariateASH or BivariateASH estimate with new data OR smoothing parameter(s)
and kernel(s).

    update!(o::UnivariateASH, y)
    update!(o::UnivariateASH, m, kernel)

    update!(o::BivariateASH, x, y)
    update!(o::BivariateASH, mx, my, kernelx, kernely)
"""
function update!(o::UnivariateASH, m::Int = o.m, kernel::Symbol = o.kernel; warnout::Bool = true)
    o.m = m
    o.kernel = kernel
    δ = o.rng.step / o.rng.divisor
    nbin = length(o.rng)
    for k = 1:nbin
        if o.v[k] != 0
            for i = maximum([1, k - o.m + 1]):minimum([nbin, k + o.m - 1])
                o.y[i] += o.v[k] * kernels[o.kernel]((i - k) / o.m)
            end
        end
    end

    o.y /= sum(o.y) * δ  # make y integrate to 1
    warnout && (o.y[1] != 0 || o.y[end] != 0) && warn("nonzero density outside of bounds")
    return
end

function update!(o::UnivariateASH, y::Vector{Float64}; warnout = true)
    updatebin!(o, y)
    update!(o, warnout = warnout)
    o
end

copy(o::UnivariateASH) = deepcopy(o)

function merge!(o1::UnivariateASH, o2::UnivariateASH)
    o1.rng == o2.rng || error("ranges do not match!")
    o1.m == o2.m || warn("smoothing parameters don't match.  Using m = $o1.m")
    o1.kernel == o2.kernel || warn("kernels don't match.  Using kernel = $o1.kernel")
    o1.n += o2.n
    o1.v += o2.v
    update!(o1)
end

function Base.show(io::IO, o::UnivariateASH)
    println(io, typeof(o))
    println(io, "*  kernel: ", o.kernel)
    println(io, "*       m: ", o.m)
    println(io, "*   edges: ", o.rng)
    println(io, "*    nobs: ", nobs(o))
    maximum(o.y) > 0 && show(io, UnicodePlots.lineplot(xy(o)...))
end

nobs(o::UnivariateASH) = o.n

nout(o::UnivariateASH) = o.n - sum(o.v)
mean(o::UnivariateASH) = mean(collect(o.rng), WeightVec(o.y))
var(o::UnivariateASH) = var(collect(o.rng), WeightVec(o.y))
std(o::UnivariateASH) = sqrt(var(o))
xy(o::UnivariateASH) = (collect(o.rng), copy(o.y))

function quantile(o::UnivariateASH, τ::Real)
    0 < τ < 1 || error("τ must be in (0, 1)")
    cdf = cumsum(o.y) * (o.rng.step / o.rng.divisor)
    i = searchsortedlast(cdf, τ)
    if i == 0
        o.rng[1]
    else
        o.rng[i] + (o.rng[i+1] - o.rng[i]) * (τ - cdf[i]) / (cdf[i+1] - cdf[i])
    end
end

function quantile{T <: Real}(o::UnivariateASH, τ::Vector{T} = [.25, .5, .75])
    [quantile(o, τi) for τi in τ]
end


function pdf(o::UnivariateASH, x::Real)
    i = searchsortedlast(o.rng, x)
    if 1 <= i < length(o.rng)
        o.y[i] + (o.y[i+1] - o.y[i]) * (x - o.rng[i]) / (o.rng[i+1] - o.rng[i])
    else
        0.0
    end
end

function pdf{T <: Real}(o::UnivariateASH, x::Array{T})
    for xi in x
        pdf(o, xi)
    end
end
