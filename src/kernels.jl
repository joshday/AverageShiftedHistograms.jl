# unnormalized kernels

inrange(u::Real) = abs(u) <= 1.0

uniform(u::Real) = inrange(u) ? 0.5 : 0.0
@vectorize_1arg Real uniform

triangular(u::Real) = inrange(u) ? 1.0 - abs(Float64(u)) : 0.0
@vectorize_1arg Real triangular

epanechnikov(u::Real) = inrange(u) ? 1.0 - Float64(u)^2 : 0.0
@vectorize_1arg Real epanechnikov

biweight(u::Real) = inrange(u) ? (1.0 - Float64(u) ^ 2) ^ 2 : 0.0
@vectorize_1arg Real biweight

triweight(u::Real) = inrange(u) ? (1.0 - Float64(u)^2)^3 : 0.0
@vectorize_1arg Real triweight

tricube(u::Real) = inrange(u) ? (1.0 - abs(Float64(u))^3)^3 : 0.0
@vectorize_1arg Real tricube

gaussian(u::Real) = exp(-0.5 * Float64(u) ^ 2)
@vectorize_1arg Real gaussian

cosine(u::Real) = inrange(u) ? cos(0.5 * π * Float64(u)) : 0.0
@vectorize_1arg Real cosine

logistic(u::Real) = 1.0 / (exp(Float64(u)) + 2.0 + exp(-Float64(u)))
@vectorize_1arg Real logistic




kernels = Dict(
    :uniform => uniform,
    :triangular => triangular,
    :epanechnikov => epanechnikov,
    :biweight => biweight,
    :triweight => triweight,
    :tricube => tricube,
    :gaussian => gaussian,
    :cosine => cosine,
    :logistic => logistic
)

const kernellist = keys(kernels)
