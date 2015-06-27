#-----------------------------------------------------------------# type: Ash1
"""
Type for storing ash estimate

- `x`:       x values
- `y`:       density at x
- `m`:       smoothing parameter
- `kernel`:  kernel
- `b`:       Bin1 object
- `non0`:    true if nonzero estimate at endpoints
"""
type Ash1
    x::Vector                            # vector of x values
    y::Vector                            # vector of y values
    m::Int                               # smoothing parameter
    kernel::Symbol                       # kernel for weighting
    b::Bin1                              # Bin1 object
    non0::Bool                   # non-zero estimate outside of interval [a, b)?
end



"""
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
"""
function Ash1(bin::Bin1; m::Int = 5, kernel::Symbol = :biweight, warnout::Bool = true)
    m > 0 || error("m must be greater than 0")
    a, b = bin.ab
    @compat δ = Float64((b - a) / bin.nbin)
    y::Vector{Float64} = zeros(bin.nbin)
    x::Vector{Float64} = zeros(bin.nbin)

    for k = 1:bin.nbin
        if bin.v != 0
            for i = maximum([1, k - m + 1]):minimum([bin.nbin, k + m - 1])
                y[i] += bin.v[k] * kernels[kernel]((i - k) / m)
            end
        end
    x[k] = a + (k - 0.5) * δ
    end

    y /= (sum(y) * δ)  # make y integrate to 1

    non0 = y[1] != 0.0 || y[end] != 0.0
    (non0 && warnout) && warn("nonzero density outside interval [a, b)")

    Ash1(x, y, m, kernel, bin, non0)
end
