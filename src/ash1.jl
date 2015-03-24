export Ash1

#-----------------------------------------------------------------------------#
#-----------------------------------------------------------------# type: Ash1
@doc doc"""
Type for storing ash estimate

- `x`:       x values
- `y`:       density at x
- `m`:       smoothing parameter
- `kernel`:  kernel
- `b`:       Bin1 object
- `non0`:    true if nonzero estimate at endpoints
"""->
type Ash1
    x::Vector                            # vector of x values
    y::Vector                            # vector of y values
    m::Int64                             # smoothing parameter
    kernel::Symbol                       # kernel for weighting
    b::Bin1                              # Bin1 object
    non0::Bool                   # non-zero estimate outside of interval [a, b)?
end



@doc doc"""
Contruct an `Ash1` object from a `Bin1` object, smoothing parameter `m`,
and `kernel`.

### `kernel` options

- :uniform
- :triangular
- :epanechnikov
- :biweight
- :triweight
- :tricube
- :gaussian
- :cosine
- :logistic
"""  ->
function Ash1(bin::Bin1; m::Int64 = 5, kernel::Symbol=:biweight)
    a, b = bin.ab
    δ = (b - a) / bin.nbin
    h = m*δ
    y = zeros(bin.nbin)
    x = [1:bin.nbin]
    for k = 1:bin.nbin
        if bin.v != 0
            for i = maximum([1, k - m + 1]):minimum([bin.nbin, k + m - 1])
                y[i] += bin.v[k]  * SmoothingKernels.kernels[kernel]((i - k) / m)
            end
        end
    end
    x = a + (x - 0.5) * δ
    y /= sum(y * δ)  # make y integrate to 1
    non0 = y[1] != 0.0 || y[end] != 0.0
    if non0
        warn("nonzero density outside interval [a, b)")
    end
    Ash1(x, y, m, kernel, bin, non0)
end
