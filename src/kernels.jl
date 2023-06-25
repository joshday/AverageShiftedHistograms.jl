module Kernels
biweight(u)         = abs(u) ≤ 1 ? (1.0 - u ^ 2) ^ 2 : 0.0
cosine(u)           = abs(u) ≤ 1 ? cos(0.5 * π * u) : 0.0
epanechnikov(u)     = abs(u) ≤ 1 ? 1.0 - u ^ 2 : 0.0
triangular(u)       = abs(u) ≤ 1 ? 1.0 - abs(u) : 0.0
tricube(u)          = abs(u) ≤ 1 ? (1.0 - abs(u) ^ 3) ^ 3 : 0.0
triweight(u)        = abs(u) ≤ 1 ? (1.0 - u ^ 2) ^ 3 : 0.0
uniform(u)          = abs(u) ≤ 1 ? 0.5 : 0.0

# Kernels that don't require -1 ≤ u ≤ 1.
gaussian(u) = exp(-0.5 * u ^ 2)
logistic(u) = 1.0 / (exp(u) + 2.0 + exp(-u))
end
