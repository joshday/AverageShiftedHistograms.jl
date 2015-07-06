
type Bin2
    v::Matrix{Int}                  # Counts in each bin
    dimx::(Float64, Float64, Int)   # (a, b, nbin))
    dimy::(Float64, Float64, Int)   # (a, b, nbin))
    n::Int                          # number of observations

    function Bin2(v::Matrix{Int},
                  dimx::(Float64, Float64, Int),
                  dimy::(Float64, Float64, Int),
                  n::Int)
        dimx[1] < dimx[2] || error("lower bound must be smaller than upper bound (x)")
        dimx[1] < dimy[2] || error("lower bound must be smaller than upper bound (y)")
        dimx[3] > 1 && dimy[3] > 1 || error("number of bins must be at least 2 for both dimensions")
        n >= 0 || error("n must be nonnegative")
        new(v, dimx, dimy, n)
    end
end

function Bin2(a1, b1, nbin1, a2, b2, nbin2)
    @compat dimx = (Float64(a1), Float64(b1), nbin1)
    @compat dimy = (Float64(a2), Float64(b2), nbin2)
    Bin2(zeros(Int, nbin1, nbin2), dimx, dimy, 0)
end

function Bin2(xedg::Range, yedg::Range)
    Bin2(minimum(xedg), maximum(xedg), length(xedg) - 1,
         minimum(yedg), maximum(yedg), length(yedg) - 1)
end

function Bin2(x::VecF, y::VecF, a1, b1, nbin1, a2, b2, nbin2)
    o = Bin2(a1, b1, nbin1, a2, b2, nbin2)
    update!(o, x, y)
    o
end

function Bin2(x::VecF, y::VecF, xedg::Range, yedg::Range)
    o = Bin2(xedg, yedg)
    update!(o, x, y)
    o
end


function update!(o::Bin2, x::Vector{Float64}, y::Vector{Float64})
    length(x) == length(y) || error("data vectors must have equal length")
    δ1 = (o.dimx[2] - o.dimx[1]) / o.dimx[3]
    δ2 = (o.dimy[2] - o.dimy[1]) / o.dimy[3]

    for i = 1:length(y)
        k1 = floor(Int, 1 + (x[i] - o.dimx[1]) / δ1)
        k2 = floor(Int, 1 + (y[i] - o.dimy[1]) / δ2)
        if 1 <= k1 <= o.dimx[3] && 1 <= k2 <= o.dimy[3]
            o.v[k1, k2] += 1
        end
    end
end



#----------------------------------------------------------------------# BivariateASH
type Ash2
    x::VecF
    y::VecF
    z::MatF         # density at (x, y)
    mx::Int64       # smoothing parameter in x direction
    my::Int64       # smoothing parameter in y direction
    kernelx::Symbol # kernel in x direction
    kernely::Symbol # kernel in y direction
    bin2::Bin2      # Bin2 object
end


# TESTING
if true
    x = randn(10_000)
    y = randn(10_000)
    a = AverageShiftedHistograms
    o = a.Bin2(x, y, -4:.1:4, -4:.1:4)
    h = hist2d([x y], -4:.1:4, -4:.1:4)
end

# """
# Contruct a `Bin2` object from two vectors of data using `nbin1` and `nbin2` bins,
# respectively.
# The default values for `ab1`/`ab2` extend `y1`'s / `y2`'s minimum/maximum by 10%
# of the range.
# """
# function Bin2(y1::Vector,
#               y2::Vector;
#               ab1::Vector = extremastretch(y1, 0.1),
#               ab2::Vector = extremastretch(y2, 0.1),
#               nbin1::Int64 = 50,
#               nbin2::Int64 = 50)
#     a1, b1 = ab1
#     a2, b2 = ab2
#     δ1 = (b1 - a1) / nbin1
#     δ2 = (b2 - a2) / nbin2
#     v = zeros(Int64, nbin1, nbin2)
#     nout = 0
#
#     for i = 1:length(y1)
#         k1 = floor(Int, 1 + (y1[i] - a1) / δ1)
#         k2 = floor(Int, 1 + (y2[i] - a2) / δ2)
#         if k1 >= 1 && k1 <= nbin1 && k2 >= 1 && k2 <= nbin2
#             v[k1, k2] += 1
#         else
#             nout += 1
#         end
#     end
#     Bin2(v, ab1, ab2, nbin1, nbin2, 0, length(y1))
# end
#
#
# """
# Update a `Bin2` object with new vectors of data
# """
# function update!(obj::Bin2, y1::Vector, y2::Vector)
#     newbin = Bin2(y1, y2,
#                   ab1 = obj.ab1, ab2 = obj.ab2,
#                   nbin1 = obj.nbin1, nbin2 = obj.nbin2)
#     obj.v += newbin.v
#     obj.nout += newbin.nout
#     obj.n += newbin.n
# end
#
#
# #------------------------------------------------------------------------# Ash2
# """
# Type for storing bivariate ash estimate
# - `x`:        x values
# - `y`:        y values
# - `z`:        density at x, y
# - `m1`:       smoothing parameter
# - `kernel1`:  kernel for x dimension
# - `kernel2`:  kernel for y dimension
# - `b`:        Bin2 object
# - `non0`:     true if nonzero estimate at endpoints
# """
# type Ash2
#     x::Vector                    # vector of x values
#     y::Vector                    # vector of y values
#     z::Matrix                    # matrix of z values
#     m1::Int64                    # smoothing parameter
#     m2::Int64                    # smoothing parameter
#     kernel1::Symbol              # kernel for weighting x
#     kernel2::Symbol              # kernel for weighting y
#     b::Bin2                      # Bin2 object
#     non0::Bool                   # non-zero estimate outside of interval [a, b)?
# end
#
#
#
#
#
# """
# # Bivariate Average Shifted Histogram
# Contruct an `Ash2` object from a `Bin2` object, smoothing parameters `m1`/`m2`,
# and kernels `kernel1`/`kernel2`.
# ### `kernel1`/ `kernel2` options:
# - :uniform
# - :triangular
# - :epanechnikov
# - :biweight
# - :triweight
# - :tricube
# - :gaussian
# - :cosine
# - :logistic
# """
# function Ash2(bin::Bin2;
#               m1::Int64 = 5,
#               m2::Int64 = 5,
#               kernel1::Symbol = :biweight,
#               kernel2::Symbol = :biweight)
#
#     a1, b1 = bin.ab1
#     a2, b2 = bin.ab2
#     nbin1 = bin.nbin1
#     nbin2 = bin.nbin2
#
#     w = zeros(2*m1 - 1, 2*m2 - 1)
#     for i = (1 - m1):(m1 - 1), j = (1 - m2):(m2 - 1)
#         w[i + m1, j + m2] = kernels[kernel1](i / m1) * kernels[kernel2](i / m2)
#     end
#
#     δ1 = (b1 - a1) / nbin1
#     δ2 = (b2 - a2) / nbin2
#     h1 = δ1 * m1
#     h2 = δ2 * m2
#
#     z = zeros(nbin1, nbin2)
#
#     for k = 1:nbin1
#        for l = 1:nbin2
#            if bin.v[k, l] == 0
#                 l += 1
#             else
#                 for i = max(1, k - m1 + 1):min(nbin1, k + m1 - 1)
#                     for j = max(1, l - m2 + 1):min(nbin2, l + m2 - 1)
#                         z[i, j] += bin.v[k, l] * w[m1 + i - k, m2 + j - l]
#                     end
#                 end
#             end
#         end
#     end
#
#     z = z / sum(z * δ1 * δ2)
#
#     x, y = [1:nbin1], [1:nbin2]
#     x = a1 + (x - 0.5) * δ1
#     y = a2 + (y - 0.5) * δ2
#
#     if any(z[1, :]!=0) || any(z[:, 1]!=0) || any(z[:, end]!=0) || any(z[end, :]!=0)
#         non0::Bool = true
#         warn("nonzero density outside of bounds")
#     end
#
#     Ash2(x, y, z, m1, m2, kernel1, kernel2, bin, non0)
# end
