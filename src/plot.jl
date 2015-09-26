
function Plots.plot(o::UnivariateASH)
    δ = o.rng.step / o.rng.divisor
    p = Plots.plot(xy(o)...)
    Plots.scatter!(p, collect(o.rng), o.v / (sum(o.v) * δ))
end


# test
# o = AverageShiftedHistograms.ash(randn(10000))
# plot(o)
