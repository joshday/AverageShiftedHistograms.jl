#------------------------------------------------------------------------# mean
function mean(b::Bin1)
    offset = .5 * (b.ab[2] - b.ab[1]) / b.nbin
    mean(linspace(b.ab[1], b.ab[2], b.nbin), WeightVec(b.v)) - offset
end


mean(a::Ash1) = mean(a.x, WeightVec(a.y))



#-------------------------------------------------------------------------# var
function var(b::Bin1)
    offset = .5 * (b.ab[2] - b.ab[1]) / b.nbin
    var(linspace(b.ab[1], b.ab[2], b.nbin) - offset, WeightVec(b.v))
end


var(a::Ash1) = var(a.x, WeightVec(a.y))



#-------------------------------------------------------------------------# cdf
function cdf(a::Ash1, x::Real)
    δ = (a.x[2] - a.x[1])
    p = 0

    for j in 1:length(a.x)
        if a.x[j] < x
            p += a.y[j]
        else
            γ = (x - a.x[j-1]) / δ
            p = γ * p + (1 - γ) * (p + a.y[j])
            break
        end
    end

    return p * δ
end

function cdf(a::Ash1, x::Vector)
    [cdf(a, xi) for xi in x]
end



#-------------------------------------------------------------------------# pdf
function Distributions.pdf(a::Ash1, x::Real)
    ax_x = abs(x - a.x)
    ind = find(ax_x .== minimum(ax_x))
    return a.y[ind][1]
end


# Accuracy depends on binwidth = (b - a) / nbin
# function quantile(a::Ash1, τ::Vector = [.25, .5, .75])
#     (minimum(τ) <= 0 || maximum(τ) >= 1) || error("probabilities must be in (0, 1)")

#     cdf = cumsum(a.y) * (a.x[2] - a.x[1])
#     result = []
#     for t in τ
#         result = [result; a.x[minimum(find(cdf .>= t))]]
#     end
#     return result
# end


# quantile(obj::Ash1, τ::Real = .5) = quantile(obj, [τ])


# This quantile function is more accurate, but not well tested
function quantile(a::Ash1, τ::Real = .5)
    (τ > 0 && τ < 1) || error("τ must be in (0,1)")

    cdf = cumsum(a.y) * (a.x[2] - a.x[1])

    ind = maximum(find(cdf .< τ))
    x1, y1 = a.x[ind], cdf[ind]
    x2, y2 = a.x[ind + 1], cdf[ind + 1]

    m = (y2 - y1) / (x2 - x1)
    b = y1 - m * x1

    return (τ - b) / m
end

quantile(a::Ash1, τ::Vector) = [quantile(a, τi) for τi in τ]



# x = rand(Distributions.Gamma(10,1), 1_000_000)

# b = AverageShiftedHistograms.Bin1(x, nbin = 1000)
# a = AverageShiftedHistograms.Ash1(b, m=3)
# println(AverageShiftedHistograms.approxquantile(a, .5))

# y = rand(Normal(), 10_000)
# bins = AverageShiftedHistograms.Bin1(y, ab = [-5, 5], nbin=1000)
# ash = AverageShiftedHistograms.Ash1(bins, m=1)
# abs(mean(y) - mean(ash))
# abs(var(y) - var(ash))

# quantile(ash, [.25, .5, .75])

# Distributions.cdf(ash, 0)
# Distributions.pdf(ash, 0)

# plot(AverageShiftedHistograms.Ash1(bins, m=40), y)

