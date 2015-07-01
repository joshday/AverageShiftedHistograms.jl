#===================================================================================#
# Bivariate Average Shifted Histograms
#
# This allows users to create an ASH estimate from a variety of contructors and
# fit methods.

# For smoothing parameters and kernels, argument is a Tuple:
# i.e., m = (3,5), kernel = (:biweight, :gaussian)
# Change the smoothing parameter `m` and `kernel` using ash!()
#===================================================================================#
#-------------------------------------------------------------# type and constructors
type BivariateASH{T<:Real}
    hist::Histogram{T, 2}             # bins
    v::Matrix{Float64}                # UnivariateASH estimate
    m::NTuple{2, Int}                 # smoothing parameter
    kernel::NTuple{2, Symbol}         # kernel
    n::Int                            # number of observations

    function BivariateASH(hist::Histogram{T, 2},
                          v::Matrix{Float64} ,
                          m::NTuple{2, Int},
                          kernel::NTuple{2, Symbol},
                          n::Int)
        n >= 0 || error("n must be greater than or equal to 0")
        m[1] > 0 && m[2] > 0 || error("smoothing parameters must be greater than 0")
        kernel[1] in kernellist && kernel[2] in kernellist|| error("kernel not recognized")
        size(v, 1) == length(hist.edges[1]) - 1 ||
            error("size(v, 1) must equal length(hist.edges[1]) - 1")
        size(v, 2) == length(hist.edges[2]) - 1 ||
            error("size(v, 2) must equal length(hist.edges[2]) - 1")
        new(hist, v, m, kernel, n)
    end
end

# Default outer constructor.  This isn't generated because of the inner constructor.
function BivariateASH{T <: Real}(hist::Histogram{T, 2},
                                 v::Matrix{Float64},
                                 m::NTuple{2, Int},
                                 kernel::NTuple{2, Symbol},
                                 n::Int)
    BivariateASH{T}(hist, v, m, kernel, n)
end

function BivariateASH(edg::NTuple{2, AbstractVector}, m::NTuple{2, Int};
                       closed::Symbol = :right,
                       bintype::Type = Int,
                       kernel::NTuple{2, Symbol} = (default_kernel, default_kernel))
    p1, p2 = length(edg[1]) - 1, length(edg[2]) - 1
    BivariateASH(Histogram(edg, bintype, closed), zeros(p1, p2), m, kernel, 0)
end

# Constructor with data
function BivariateASH(y::Matrix, edg::NTuple{2, AbstractVector}, m::NTuple{2, Int};
                       closed::Symbol = :right,
                       bintype::Type = Int,
                       kernel::NTuple{2, Symbol} = (default_kernel, default_kernel))
    p1, p2 = length(edg[1]) - 1, length(edg[2]) - 1
    o = BivariateASH(Histogram(edg, bintype, closed), zeros(p1, p2), m, kernel, 0)
    update!(o, y)
    o
end

#---------------------------------------------------------------------------# update!
function update!{T <: Real}(o::BivariateASH, y::NTuple{2, Vector{T}}, ash::Bool = true)
    length(y[1]) == length(y[2]) || error("input data must have same length")
    append!(o.hist, y)
    o.n += length(y[1])
    ash && ash!(o)
end

function update!{T <: Real}(o::BivariateASH, y::Matrix{T}, ash::Bool = true)
    update!(o, (y[:,1], y[:,2]), ash)
end


#------------------------------------------------------------------------------# Base
function Base.show(io::IO, o::BivariateASH)
    println(io, typeof(o))
    println(io, "*  kernel: ", o.kernel)
    println(io, "*       m: ", o.m)
    println(io, "*   nbins: ", (length(o.hist.edges[1]),length(o.hist.edges[2])))
end
Base.copy(o::BivariateASH) = deepcopy(o)
function Base.merge!(o::BivariateASH)
    # TODO
end
Base.merge(o::BivariateASH) = merge!(copy(o))


#-----------------------------------------------------------------# functions/methods
value(o::BivariateASH) = copy(o.v)
nobs(o::BivariateASH) = o.n
midpoints(o::BivariateASH) = (midpoints(o.hist.edges[1]), midpoints(o.hist.edges[1]))

function ash!(o::BivariateASH, m::NTuple{2, Int} = o.m, kernel::NTuple{2, Symbol} = o.kernel;
              warnout = true)
    o.m = m
    o.kernel = kernel
    p1, p2 = length(o.hist.edges[1]) - 1, length(o.hist.edges[2]) - 1

    w = zeros(2 * o.m[1] - 1, 2 * o.m[2] - 1)
    for i = (1 - o.m[1]):(o.m[1] - 1), j = (1 - o.m[2]):(o.m[2] - 1)
        w[i + o.m[1], j + o.m[2]] = kernels[o.kernel[1]](i / o.m[1]) * kernels[o.kernel[2]](i / o.m[2])
    end

    for k = 1:p1
       for l = 1:p2
           if o.hist.weights[k, l] == 0
                l += 1
            else
                for i = max(1, k - o.m[1] + 1):min(p1, k + o.m[1] - 1)
                    for j = max(1, l - o.m[2] + 1):min(p2, l + o.m[2] - 1)
                        o.v[i, j] += o.hist.weights[k, l] * w[m[1] + i - k, m[2] + j - l]
                    end
                end
            end
        end
    end

    @compat δ1 = Float64((o.hist.edges[1][2] - o.hist.edges[1][1]))
    @compat δ2 = Float64((o.hist.edges[2][2] - o.hist.edges[2][1]))
    o.v /= sum(o.v) * δ1 * δ2
    return
end

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
# TESTING
if false
    println(""); println("")
    p = length(-4:.1:4) - 1
    h = fit(Histogram, (randn(1000), randn(1000)), (-4:.1:4, -4:.1:4))
    o = BivariateASH(h, zeros(p, p), (5,10), (:uniform, :logistic), 0)
    copy(o)
    o = BivariateASH((1:10, 1:10), (5, 5))
    y = randn(100, 100)
    o = BivariateASH(y, (-4:.1:4, -4:.1:4), (5,5))
    show(o)
    nobs(o)
    println(midpoints(o))
end
