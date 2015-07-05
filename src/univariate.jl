# Bin1 is slightly different from Histogram in StatsBase because:
#
# 1) bins are forced to have equal width.  This makes calculations for updating easier and faster.
# 2) Bin1 keeps track of how many observations fall outside the endpoints.
# 3) Does not do weighted counts (bin counts can only be of type Int64)
#------------------------------------------------------------------------------# Bin1
type Bin1
    v::Vector{Int}        # Counts in each bin
    a::Float64            # lower bound
    b::Float64            # uppwer bound
    nbin::Int             # number of bins
    n::Int                # number of observations

    function Bin1(v::Vector{Int}, a::Float64, b::Float64, nbin::Int, n::Int)
        length(v) == nbin || error("length of count vector must match nbins")
        a < b || error("lower bound must be smaller than upper bound")
        nbin > 1 || error("must use at least 2 bins")
        n >= 0 || error("n must be nonnegative")
        new(v, a, b, nbin, n)
    end
end

@compat Bin1(a, b, nbin) = Bin1(zeros(Int, nbin), Float64(a), Float64(b), nbin, 0)

function Bin1(y::Vector{Float64}, a, b, nbin)
    o = Bin1(a, b, nbin)
    push!(o, y)
    o
end

Bin1(y::Vector{Float64}, r::Range) = Bin1(y, minimum(r), maximum(r), length(r) - 1)

function push!(o::Bin1, y::Vector{Float64})
    @compat δ = Float64((o.b - o.a) / o.nbin)
    o.n += length(y)
    for yi in y
        ki::Int = floor(Int, (yi - o.a) / δ + 1)
        if 1 <= ki <= o.nbin
            o.v[ki] += 1
        end
    end
    nothing
end

copy(o::Bin1) = deepcopy(o)

function merge!(o1::Bin1, o2::Bin1)
    o1.a == o2.a && o1.b == o2.b || error("objects have different endpoints")
    o1.nbin == o2.nbin || error("objects have different number of bins")
    o1.n += o2.n
    o1.v += o2.v
end



#------------------------------------------------------------------------------# Ash1
type UnivariateASH
    x::Vector                            # vector of x values
    y::Vector                            # vector of y values
    m::Int                               # smoothing parameter
    kernel::Symbol                       # kernel for weighting
    bin1::Bin1                           # Bin1 object
end

"Univariate Average Shifted Histogram"
function UnivariateASH(o::Bin1, m::Int, kernel::Symbol = :biweight, warnout::Bool = true)
    m > 0 || error("m must be greater than 0")
    @compat δ = Float64((o.b - o.a) / o.nbin)
    y::Vector{Float64} = zeros(o.nbin)
    x::Vector{Float64} = zeros(o.nbin)

    for k = 1:o.nbin
        if o.v != 0
            for i = maximum([1, k - m + 1]):minimum([o.nbin, k + m - 1])
                y[i] += o.v[k] * kernels[kernel]((i - k) / m)
            end
        end
    x[k] = o.a + (k - 0.5) * δ
    end

    y /= (sum(y) * δ)  # make y integrate to 1

    non0 = y[1] != 0.0 || y[end] != 0.0
    (non0 && warnout) || warn("nonzero density outside interval [a, b)")

    UnivariateASH(x, y, m, kernel, o)
end

"Get ASH estimate specifying the bin edges (nbins = length(edg) - 1)"
function fit(::Type{UnivariateASH}, y::Vector{Float64}, edg::Range, m::Int,
             kernel::Symbol = :biweight; warnout::Bool = true)
    bins = Bin1(y, edg)
    UnivariateASH(bins, m, kernel, warnout)
end

"Get ASH estimate specifying the endpoints and nbins"
function fit(::Type{UnivariateASH}, y::Vector{Float64}, a, b, nbin, m::Int,
             kernel::Symbol = :biweight; warnout::Bool = true)
    bins = Bin1(y, a, b, nbin)
    UnivariateASH(bins, m, kernel, warnout)
end

"Change the smoothing parameter and kernel for the UnivariateASH estimate"
function ash!(o::UnivariateASH, m::Int = o.m, kernel::Symbol = o.kernel; warnout = true)
    o.m = m
    o.kernel = kernel
    δ = (o.bin1.b - o.bin1.a) / o.bin1.nbin
    for k = 1:o.bin1.nbin
        if o.bin1.v[k] != 0
            for i = maximum([1, k - o.m + 1]):minimum([o.bin1.nbin, k + o.m - 1])
                o.y[i] += o.bin1.v[k] * kernels[o.kernel]((i - k) / o.m)
            end
        end
    end

    o.y /= sum(o.y) * δ  # make y integrate to 1
    o.y[1] != 0 || o.y[end] != 0 && warn("nonzero density outside of bounds")
    return
end

"Update UnivariateASH with new data and optional new smoothing parameter/kernel"
function update!(o::UnivariateASH, y::Vector{Float64}, m::Int = o.m, kernel::Symbol = o.kernel)
    push!(o.bin1, y)
    ash!(o, m, kernel)
end

copy(o::UnivariateASH) = deepcopy(o)

merge!(o1::UnivariateASH, o2::UnivariateASH) = (merge!(o1.bin1, o2.bin1); ash!(o1))

function Base.show(io::IO, o::UnivariateASH)
    println(io, typeof(o))
    println(io, "*  kernel: ", o.kernel)
    println(io, "*       m: ", o.m)
    println(io, "*   nbins: ", o.bin1.nbin)
    println(io, "*    nobs: ", nobs(o))
    maximum(o.y) > 0 && TextPlots.plot(o.x, o.y, title = false, cols=30, rows=10)
end

nobs(o::UnivariateASH) = o.bin1.n

"return the number of observations outside the endpoints of the histogram bins"
nout(o::UnivariateASH) = o.bin1.n - sum(o.bin1.v)
mean(o::UnivariateASH) = mean(o.x, WeightVec(o.y))
var(o::UnivariateASH) = var(o.x, WeightVec(o.y))
std(o::UnivariateASH) = sqrt(var(o))
