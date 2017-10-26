module Tests
using AverageShiftedHistograms, StatsBase, Base.Test, Distributions

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
    @test quantile(o, 1e-20) ≈ first(o.rng) atol = .2

    # check that histogram is correct
    h = fit(Histogram, x, (-4:.1:4.1)-.05; closed = :left)
    @test h.weights == o.counts

    ash!(o, x)
    @test nobs(o) == 20_000
    @test pdf(o, -5) == 0
    @test pdf(o, 5) == 0
    @test pdf(o, 0) > 0
    @test cdf(o, -5) == 0
    @test cdf(o, 0) ≈ .5 atol=.05
    @test cdf(o, 5) ≈ 1

    o = ash([.1, .1]; rng = -1:.1:1)
    @test nout(o) == 0

    y = randn(100)
    y2 = randn(100)

    @test ash(y) == ash(y)

    a = ash(y; rng = -5:.1:5)
    ash!(a, y2)
    a2 = ash(vcat(y, y2); rng = -5:.1:5)
    @test a == a2
    a3 = merge(ash(y, rng=-5:.1:5), ash(y2, rng=-5:.1:5))
    @test a == a3
end

# @testset "Ash merge" begin
#     y, y2 = randn(100), randn(100)
#     o1 = ash(y; rng = -4:.1:4)
#     o2 = ash(y2; rng = -4:.1:4)
#     merge!(o1, o2)
#     ash!(o2, y)

#     o3 = ash(vcat(y, y2); rng = -4:.1:4)

#     @test nobs(o1)      == nobs(o3)
#     @test o1.counts     == o3.counts
#     @test o1.m          == o3.m
#     @test o1.kernel     == o3.kernel
#     @test o1.rng        == o3.rng
#     for j in 1:length(o1.density)
#         @test o1.density[j] == o3.density[j]
#     end
# end

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
