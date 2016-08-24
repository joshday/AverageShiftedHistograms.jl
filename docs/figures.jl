module Figures
using AverageShiftedHistograms, Distributions
using Plots
pyplot()


o = ash(rand(Gamma(5, 1), 0), 0:.05:20, m = 15)
sz = 20
anim = @animate for i in 1:50
    fit!(o, rand(Gamma(5, 1), sz); warnout = false)
    plot(o, title = "Nobs = $(10 * i)", ylim = (0, .5))
end
gif(anim, "animation.gif", fps = 10)





end
