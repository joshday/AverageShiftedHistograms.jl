kernellist = [:uniform, :triangular, :epanechnikov, :biweight,
              :triweight, :tricube, :gaussian, :cosine, :logistic]

#-------------------------------------------------------# type and constructors
type UnivariateASH{T<:Real}
    hist::Histogram{T, 1}             # bins
    v::Vector{Float64}                # UnivariateASH estimate
    m::Int                            # smoothing parameter
    kernel::Symbol                    # kernel
    n::Int                            # number of observations

    function UnivariateASH(hist::Histogram{T, 1}, v::Vector{Float64}, m::Int, kernel::Symbol, n::Int)
        n >= 0 || error("n must be greater than or equal to 0")
        m > 0 || error("smoothing parameter m must be greater than 0")
        kernel ∈ kernellist || error("kernel not recognized")
        length(v) == length(hist.edges[1]) - 1 || error("length(v) must be one less than length(hist.edges)")
        new(hist, v, m, kernel, n)
    end
end

# Default outer constructor.  This doesn't get made automatically because of the inner constructor.
function UnivariateASH{T <: Real}(hist::Histogram{T, 1}, v::Vector{Float64}, m::Int, kernel::Symbol, n::Int)
    UnivariateASH{T}(hist, v, m, kernel, n)
end

function UnivariateASH(edg::AbstractVector, T::Type = Int, closed::Symbol = :right)
    UnivariateASH(Histogram(edg, T, closed), zeros(length(edg) - 1), 1, :biweight, 0)
end

function UnivariateASH(a::Real, b::Real, nbin::Integer, T::Type = Int, closed::Symbol = :right)
    UnivariateASH(linspace(a, b, nbin), T, closed)
end


# Constructor with data (user provides endpoints and nbins)
function UnivariateASH(y::Vector, a::Real, b::Real, nbin::Int, T::Type = Int, closed::Symbol = :right)
    o = UnivariateASH(a, b, nbin, T, closed)
    update!(o, y)
    o
end
# Constructor with data (user provide edges)
function UnivariateASH(y::Vector, edg::AbstractVector, T::Type = Int, closed::Symbol = :right)
    o = UnivariateASH(edge, T, closed)
    update!(o, y)
    o
end

#---------------------------------------------------------------------# update!
function update!(o::UnivariateASH, y::Real, ash::Bool = true)
    push!(o.hist, y)
    ash && ash!(o)
end

function update!{T <: Real}(o::UnivariateASH, y::Vector{T})
    for yi in y; update!(o, yi, false); end
    ash!(o)
end


#---------------------------------------------------------------------# Base
function Base.show(io::IO, o::UnivariateASH)
    println(io, typeof(o))
    println(io, "*  kernel: ", o.kernel)
    println(io, "*       m: ", o.m)
    println(io, "*   edges:", o.hist.edges[1])
end

Base.copy(o::UnivariateASH) = deepcopy(o)

function Base.merge!(o::UnivariateASH)
end

Base.merge(o::UnivariateASH) = merge!(copy(o))


#-----------------------------------------------------------# functions/methods
nout(o::UnivariateASH) = nobs(o) - sum(b.v)
nobs(o::UnivariateASH) = b.n
midpoints(o::UnivariateASH) = midpoints(o.hist.edges[1])

function ash!(o::UnivariateASH, m::Int = o.m, warnout = true)
    o.m = m
    nbins = length(o.hist.edges[1]) - 1
    @compat δ = Float64((o.hist.edges[1][2] - o.hist.edges[1][1]))
    for k = 1:nbins
        if o.hist.weights[k] != 0
            for i = maximum([1, k - o.m + 1]):minimum([nbins, k + o.m - 1])
                o.v[i] += o.hist.weights[k] * kernels[o.kernel]((i - k) / o.m)
            end
        end
    end

    o.v /= (sum(o.v) * δ)  # make y integrate to 1
    o.v[1] != 0 || o.v[end] != 0 && warn("out")
    return
end


# TESTING
if true
    h = fit(Histogram, randn(1000), -4:.1:4)
    o = AverageShiftedHistograms.UnivariateASH([-4:.1:4], Float64)
    o = AverageShiftedHistograms.UnivariateASH(-4, 4, 50)
    o = AverageShiftedHistograms.UnivariateASH(randn(100), -4, 4, 50)
#     AverageShiftedHistograms.ash!(o, 4)
end
