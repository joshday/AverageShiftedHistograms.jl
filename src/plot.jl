#-----------------------------------------------------------# Bin1/Ash1 methods
"Plot an `Bin1` object"
function plot(b::Bin1)
    δ = (b.ab[2] - b.ab[1]) / b.nbin
    plot(x = linspace(b.ab[1], b.ab[2], b.nbin), y = b.v / (sum(b.v) * δ),
         Geom.point, Theme(default_point_size = 1.5pt, default_color = color("black")))
end


"Plot an `Ash1` density estimate"
function plot(a::Ash1)
    plot(x = a.x, y = a.y, Geom.line, Theme(default_color = color("black")))
end


"Plot `Bin1` and `Ash1` objects together.  The comparison can be used to check
for oversmoothing."
function plot(b::Bin1, a::Ash1)
    δ = (b.ab[2] - b.ab[1]) / b.nbin
    plot(layer(x = linspace(b.ab[1], b.ab[2], b.nbin), y = b.v / (sum(b.v) * δ),
               Geom.point, Theme(highlight_width = 0pt, default_point_size = 1.5pt,
                                 default_color = color("black"))),
         layer(x = a.x, y = a.y, Geom.line, Theme(default_color = color("black"))))
end


"Plot `Ash1` object with data `y`"
function plot(a::Ash1, y::Vector)
    plot(
        layer(x = a.x, y = a.y, Geom.line, Theme(default_color = color("black"))),
        layer(x = y, Geom.histogram(density = true)))
end


"Plot `Bin1`, `Ash1`, and data `y` together"
function plot(b::Bin1, a::Ash1, y::Vector)
    δ = (b.ab[2] - b.ab[1]) / b.nbin
    plot(
        layer(x = linspace(b.ab[1], b.ab[2], b.nbin), y = b.v / (sum(b.v) * δ),
               Geom.point, Theme(highlight_width = 0pt, default_point_size = 1.5pt,
                                 default_color = color("black"))),
        layer(x = a.x, y = a.y, Geom.line, Theme(default_color = color("black"))),
        layer(x = y, Geom.histogram(density = true)))
end


#-----------------------------------------------------------# Bin2/Ash2 methods
"Plot an `Ash2`density estimate"
function plot(obj::Ash2; levels=10, args...)
    plot(x = obj.x, y=obj.y, z=obj.z, Geom.contour(levels=levels), args...)
end


# testing
# x = rand(Distributions.Gamma(10,1), 1_000_000)
# @time b = AverageShiftedHistograms.Bin1(x, nbin = 100)
# @time a = AverageShiftedHistograms.Ash1(b, m = 1)
# println(cdf(a, 10) - cdf(Distributions.Gamma(10,1), 10))
# println(cdf(a,[0:10]) - cdf(Distributions.Gamma(10,1), [0:10]))


# x2 = rand(Distributions.Gamma(10,1), 1_000_000)
# @time AverageShiftedHistograms.updatebatch!(b, x2)

# @time b2 = AverageShiftedHistograms.Bin1(x, nbin = 1000)
# @time merge(b, b2)
# @time merge!(b, b2)
# plot(b)
# plot(a)
# plot(b, a)
# plot(b, a, x)
# plot(a, x)

