module Figures
using AverageShiftedHistograms, Distributions, Plots
gr()


# sz = 1000
# o = ash(rand(Gamma(5, 1), sz), rng=0:.05:20, m = 15)

# anim = @animate for i in 1:50
#     plot(o, title = "Nobs = $(sz * i)", ylim = (0, .5))
#     ash!(o, rand(Gamma(5, 1), sz))
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
