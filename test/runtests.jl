module Tests
using AverageShiftedHistograms, StatsBase, Base.Test

info("Messy Output")
show(ash(randn(1000)))
show(ash(randn(100), randn(100)))
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
    x = randn(10_000)
    o = ash(x, rng = -4:.1:4)


    for f in [mean, var, std, x -> quantile(x, .4), x -> quantile(x, .4:.1:.6)]
        @test f(o) ≈ f(x) atol=.1
    end
    AverageShiftedHistograms.histdensity(o)
    @test quantile(o, 1e-20) ≈ first(o.rngx) atol = .2

    # check that histogram is correct
    h = fit(Histogram, x, (-4:.1:4.1)-.05; closed = :left)
    @test h.weights == o.counts

    ash!(o, x)
    @test nobs(o) == 20_000

    o = ash([.1, .1]; rngx = -1:.1:1)
    @test nout(o) == 0
end

@testset "Ash2" begin
    x = randn(1000)
    y = x + randn(1000)
    o = ash(x, y)

    @test nobs(o) == 1000

    o = ash([1,2], [1,2])
    @test nout(o) == 0

    mean(o)
    var(o)
    std(o)
    xyz(o)
end

end #module
