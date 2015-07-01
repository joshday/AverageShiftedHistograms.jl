#----------------------------------------------------------# univariate methods
# function plot_hist(o::UnivariateASH)
#     mid = midpoints(o)
#     ys = o.hist.weights
#     ys /= sum(ys) * (mid[2] - mid[1])
#     plot(x = mid, y = ys, Geom.point, Theme(discrete_highlight_color=c->nothing))
# end

# function plot_ash(o::UnivariateASH)
#     plot(x = midpoints(o), y = o.v, Geom.line, Theme(default_color = color("black")))
# end

# function plot_both(o::UnivariateASH)
#     mid = midpoints(o)
#     ys = o.hist.weights
#     ys /= sum(ys) * (mid[2] - mid[1])
#     plot(
#         layer(x = midpoints(o), y = o.v, Geom.line, Theme(default_color = color("black"))),
#         layer(x = midpoints(o), y = ys, Geom.point, Theme(discrete_highlight_color=c->nothing))
#     )
# end

# function Gadfly.plot(o::UnivariateASH, hist::Bool = true, ash::Bool = true)
#     if hist && ash
#         plot_both(o)
#     elseif hist && !ash
#         plot_hist(o)
#     elseif !hist && ash
#         plot_ash(o)
#     else
#         error("either hist or ash must be true")
#     end
# end
