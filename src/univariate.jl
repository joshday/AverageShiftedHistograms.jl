# Docs
"""
`update!(o, y)`
`update!(o, m, [, kernel])`

Update a UnivariateASH object with new data or change the smoothing parameter and kernel
"""
:update!

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

function UnivariateASH(y::VecF, rng::Range; m::Int = 5, kernel::Symbol = :biweight)
    @compat myrng = FloatRange(Float64(rng.start), Float64(rng.step), Float64(rng.len), Float64(rng.divisor))
    o = UnivariateASH(rng, m, kernel)
    updatebin!(o, y)
    update!(o)
    o
end

ash(y::VecF, rng::Range; m::Int = 5, kernel::Symbol = :biweight) = UnivariateASH(y, rng, m = m, kernel = kernel)
function fit(::Type{UnivariateASH}, y::VecF, rng::Range; m::Int = 5, kernel::Symbol = :biweight)
    ash(y, rng, m = m, kernel = kernel)
end


function updatebin!(o::UnivariateASH, y::Vector{Float64})
    δ = o.rng.step / o.rng.divisor
    a = o.rng[1]
    nbin = length(o.rng)
    o.n += length(y)
    for yi in y
        ki::Int = floor(Int, (yi - a) / δ)
        if 1 <= ki <= nbin
            o.v[ki] += 1
        end
    end
    nothing
end

function update!(o::UnivariateASH, m::Int = o.m, kernel::Symbol = o.kernel; warnout = true)
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
    o.y[1] != 0 || o.y[end] != 0 && warn("nonzero density outside of bounds")
    return
end

function update!(o::UnivariateASH, y::Vector{Float64})
    updatebin!(o, y)
    update!(o)
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
    maximum(o.y) > 0 && TextPlots.plot([o.rng], o.y, title = false, cols=30, rows=10)
end

nobs(o::UnivariateASH) = o.n

nout(o::UnivariateASH) = o.n - sum(o.v)
mean(o::UnivariateASH) = mean([o.rng], WeightVec(o.y))
var(o::UnivariateASH) = var([o.rng], WeightVec(o.y))
std(o::UnivariateASH) = sqrt(var(o))
xy(o::UnivariateASH) = ([o.rng], copy(o.y))

function quantile(o::UnivariateASH, τ::Real)
    0 < τ < 1 || error("τ must be in (0, 1)")
    cdf = cumsum(o.y) * (o.rng.step / o.rng.divisor)

    o.rng[minimum(find(cdf .>= τ))]
end

function Grid.CoordInterpGrid(o::UnivariateASH)
    Grid.CoordInterpGrid(o.rng, o.y, 0.0, Grid.InterpLinear)
end