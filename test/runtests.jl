module Tests
using AverageShiftedHistograms, StatsBase, Base.Test

info("Messy Output")
show(ash(randn(1000)))
println("\n\n")
info("Begin Tests")


@testset "Kernels" begin
    for kernel in [Kernels.biweight,
                   Kernels.cosine,
                   Kernels.epanechnikov,
                   Kernels.triangular,
                   Kernels.tricube,
                   Kernels.triweight,
                   Kernels.uniform,
                   Kernels.gaussian,
                   Kernels.logistic]
        for u in [0.0, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1.0, 10.0]
            @test kernel(-u) ≈ kernel(u)
        end
    end
end

@testset "Ash" begin
    y = randn(10_000)
    o = ash(y, -4:.1:4; warnout = false)

    for f in [mean, var, std, x -> quantile(x, .4), x -> quantile(x, .4:.1:.6)]
        @test_approx_eq_eps f(o) f(y) .1
    end

    # check that histogram is correct
    h = fit(Histogram, y, (-4:.1:4.1)-.05)
    @test h.weights == o.v

    fit!(o, y; warnout = false)
    @test nobs(o) == 20_000
end

end #module
