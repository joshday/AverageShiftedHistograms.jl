"""
The Kernels module defines a collection of kernels to avoid namespace collisions:

- `biweight`
- `cosine`
- `epanechnikov`
- `triangular`
- `tricube`
- `triweight`
- `uniform`
- `gaussian`
- `logistic`
"""
module Kernels
in_range(u) = abs(u) ≤ 1

biweight(u)         = in_range(u) ? (1.0 - u ^ 2) ^ 2 : 0.0
cosine(u)           = in_range(u) ? cos(0.5 * π * u) : 0.0
epanechnikov(u)     = in_range(u) ? 1.0 - u ^ 2 : 0.0
triangular(u)       = in_range(u) ? 1.0 - abs(u) : 0.0
tricube(u)          = in_range(u) ? (1.0 - abs(u) ^ 3) ^ 3 : 0.0
triweight(u)        = in_range(u) ? (1.0 - u ^ 2) ^ 3 : 0.0
uniform(u)          = in_range(u) ? 0.5 : 0.0

gaussian(u) = exp(-0.5 * u ^ 2)
logistic(u) = 1.0 / (exp(u) + 2.0 + exp(-u))
end
