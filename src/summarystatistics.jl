function Base.mean(obj::Ash1)
    bw = obj.x[2] - obj.x[1]
    xfx = obj.x .* obj.y
    return sum(xfx) * bw
end

function Base.var(obj::Ash1)
    bw = obj.x[2] - obj.x[1]
    m2 = (obj.x - mean(obj)) .^ 2
    m2 = m2 .* obj.y
    return sum(m2) * bw
end

function Distributions.cdf(obj::Ash1, x::Real)
    cdf = cumsum(obj.y) * (obj.x[2] - obj.x[1])
    obx_x = abs(x - obj.x)
    ind = find(obx_x .== minimum(obx_x))
    return cdf[ind][1]
end

function Distributions.pdf(obj::Ash1, x::Real)
    obx_x = abs(x - obj.x)
    ind = find(obx_x .== minimum(obx_x))
    return obj.y[ind][1]
end

# Accuracy depends on binwidth = (b - a) / nbin
function quantile(obj::Ash1, τ::Vector = [.25, .5, .75])
    if minimum(τ) <= 0 || maximum(τ) >= 1
        error("probabilities must be in (0, 1)")
    end
    cdf = cumsum(obj.y) * (obj.x[2] - obj.x[1])
    result = []
    for t in τ
        result = [result; obj.x[minimum(find(cdf .>= t))]]
    end
    return result
end

quantile(obj::Ash1, τ::Real = .5) = quantile(obj, [τ])





# y = rand(Normal(), 10_000)
# bins = AverageShiftedHistograms.Bin1(y, ab = [-5, 5], nbin=1000)
# ash = AverageShiftedHistograms.Ash1(bins, m=1)
# abs(mean(y) - mean(ash))
# abs(var(y) - var(ash))

# quantile(ash, [.25, .5, .75])

# Distributions.cdf(ash, 0)
# Distributions.pdf(ash, 0)

# plot(AverageShiftedHistograms.Ash1(bins, m=40), y)

