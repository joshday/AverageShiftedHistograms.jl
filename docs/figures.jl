module Figures
using AverageShiftedHistograms, Distributions, Plots
gr()


# o = ash(rand(Gamma(5, 1), 0), 0:.05:20, m = 15)
# sz = 20
# anim = @animate for i in 1:50
#     fit!(o, rand(Gamma(5, 1), sz); warnout = false)
#     plot(o, title = "Nobs = $(10 * i)", ylim = (0, .5))
# end
# gif(anim, "animation.gif", fps = 10)



# k = [
#     Kernels.biweight,
#     Kernels.cosine,
#     Kernels.epanechnikov,
#     Kernels.triangular,
#     Kernels.tricube,
#     Kernels.uniform,
#     Kernels.gaussian,
#     Kernels.logistic
# ]
# l = [
#     "biweight"
#     "cosine"
#     "epanechnikov"
#     "triangular"
#     "tricube"
#     "uniform"
#     "gaussian"
#     "logistic"
# ]
# plot(k, -1.1, 1.1, palette = :darktest, label = l, line=:auto, w=2)



end
