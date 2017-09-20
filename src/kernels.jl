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
inrange(u::Float64) = abs(u) <= 1.0

biweight(u::Float64)        = inrange(u) ? (1.0 - u ^ 2) ^ 2 : 0.0
cosine(u::Float64)          = inrange(u) ? cos(0.5 * π * u) : 0.0
epanechnikov(u::Float64)    = inrange(u) ? 1.0 - u ^ 2 : 0.0
triangular(u::Float64)      = inrange(u) ? 1.0 - abs(u) : 0.0
tricube(u::Float64)         = inrange(u) ? (1.0 - abs(u) ^ 3) ^ 3 : 0.0
triweight(u::Float64)       = inrange(u) ? (1.0 - u ^ 2) ^ 3 : 0.0
uniform(u::Float64)         = inrange(u) ? 0.5 : 0.0

gaussian(u::Float64) = exp(-0.5 * u ^ 2)
logistic(u::Float64) = 1.0 / (exp(u) + 2.0 + exp(-u))
end
