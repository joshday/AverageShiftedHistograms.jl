export Ash2


#-----------------------------------------------------------------------------#
#-----------------------------------------------------------------# type: Ash2
@doc md"""
Type for storing bivariate ash estimate

| Field                      | Description
|:---------------------------|:------------------------------
| `x::Vector`                | x values
| `y::Vector`                | y values
| `z::Matrix`                | density at x, y
| `m1::Int64`                | smoothing parameter
| `kernel1::Symbol`          | kernel for x dimension
| `kernel2::Symbol`          | kernel for y dimension
| `b`                        | Bin2 object
| `non0::Bool`               | true if nonzero estimate at endpoints
""" ->
type Ash2
    x::Vector                    # vector of x values
    y::Vector                    # vector of y values
    z::Matrix                    # matrix of z values
    m1::Int64                    # smoothing parameter
    m2::Int64                    # smoothing parameter
    kernel1::Symbol              # kernel for weighting x
    kernel2::Symbol              # kernel for weighting y
    b::Bin2                      # Bin2 object
    non0::Bool                   # non-zero estimate outside of interval [a, b)?
end





@doc md"""
# Bivariate Average Shifted Histogram

Contruct an `Ash2` object from a `Bin2` object, smoothing parameters `m1`/`m2`,
and kernels `k1`/`k2`.

### `k1`/ `k2` options:

- :uniform
- :triangular
- :epanechnikov
- :biweight
- :triweight
- :tricube
- :gaussian
- :cosine
- :logistic

""" ->
function Ash2(bin::Bin2;
              m1::Int64 = 5,
              m2::Int64 = 5,
              kernel1::Symbol = :biweight,
              kernel2::Symbol = :biweight)

    a1, b1 = bin.ab1
    a2, b2 = bin.ab2
    nbin1 = bin.nbin1
    nbin2 = bin.nbin2

    w = zeros(2*m1 - 1, 2*m2 - 1)
    for i = (1 - m1):(m1 - 1), j = (1 - m2):(m2 - 1)
        w[i + m1, j + m2] = SmoothingKernels.kernels[kernel1](i / m1) *
            SmoothingKernels.kernels[kernel2](i / m2)
    end

    δ1 = (b1 - a1) / nbin1
    δ2 = (b2 - a2) / nbin2
    h1 = δ1 * m1
    h2 = δ2 * m2

    z = zeros(nbin1, nbin2)

    for k = 1:nbin1
       for l = 1:nbin2
           if bin.v[k, l] == 0
                l += 1
            else
                for i = max(1, k - m1 + 1):min(nbin1, k + m1 - 1)
                    for j = max(1, l - m2 + 1):min(nbin2, l + m2 - 1)
                        z[i, j] += bin.v[k, l] * w[m1 + i - k, m2 + j - l]
                    end
                end
            end
        end
    end

    z = z / sum(z * δ1 * δ2)

    x, y = [1:nbin1], [1:nbin2]
    x = a1 + (x - 0.5) * δ1
    y = a2 + (y - 0.5) * δ2

    if any(z[1, :]!=0) || any(z[:, 1]!=0) || any(z[:, end]!=0) || any(z[end, :]!=0)
        non0::Bool = true
        warn("nonzero density outside of bounds")
    end

    Ash2(x, y, z, m1, m2, kernel1, kernel2, bin, non0)
end
