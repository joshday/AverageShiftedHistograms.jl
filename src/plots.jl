@recipe function f(o::UnivariateASH)
    seriestype --> [:line :sticks]
    label --> ["ASH" "Histogram"]
    linewidth --> [2 1]
    δ = o.rng.step / o.rng.divisor
    x1, y1 = xy(o)
    x2 = collect(o.rng)
    y2 = o.v / (sum(o.v) * δ)
    hcat(x1, x2), hcat(y1, y2)
end
