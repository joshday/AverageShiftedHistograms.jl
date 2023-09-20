module Tests
using AverageShiftedHistograms, Test, StatsBase, Statistics, LinearAlgebra

@info("Messy Output")
show(ash(randn(1000)))
show(ash(randn(100), randn(100)))
println("\n\n")
@info("Begin Tests")


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
    o = ash(x, rng = -7:.01:7)
    @test extrema(o)[1] ≈ extrema(x)[1] atol=0.01
    @test extrema(o)[2] ≈ extrema(x)[2] atol=0.01

    for f in [mean, var, std, x -> quantile(x, .4), x -> quantile(x, .4:.1:.6)]
        @test f(o) ≈ f(x) atol=.1
    end
    AverageShiftedHistograms.histdensity(o)
    @test quantile(o, 0) ≈ o.rng[findnext(x -> x != 0, o.counts, 1)]

    # check that histogram is correct
    h = fit(Histogram, x, (-7:.01:7.01) .- .005; closed = :left)
    @test h.weights == o.counts

    ash!(o, x)
    @test nobs(o) == 20_000
    @test AverageShiftedHistograms.pdf(o, -5) == 0
    @test AverageShiftedHistograms.pdf(o, 5) == 0
    @test AverageShiftedHistograms.pdf(o, 0) > 0
    @test AverageShiftedHistograms.cdf(o, -5) == 0
    @test AverageShiftedHistograms.cdf(o, 0) ≈ .5 atol=.05
    @test AverageShiftedHistograms.cdf(o, 5) ≈ 1

    o = ash([.1, .1]; rng = -1:.1:1)
    @test nout(o) == 0

    # merging
    y = randn(100)
    y2 = randn(100)

    @test ash(y) == ash!(ash(y))

    a = ash(y; rng = -5:.1:5)
    ash!(a, y2)
    a2 = ash(vcat(y, y2); rng = -5:.1:5)
    @test a == a2
    a3 = merge(ash(y, rng=-5:.1:5), ash(y2, rng=-5:.1:5))
    @test a == a3

    # push!
    a = ash(y; rng = -5:.1:5)
    a2 = ash([y[1]]; rng = -5:.1:5)
    for i in 2:length(y)
        push!(a2, y[i])
    end
    ash!(a2)
    @test a == a2
end


@testset "Ash2" begin
    x = randn(1000)
    y = x + randn(1000)
    o = ash(x, y)

    @test ash(x, y) == ash!(ash(x, y))

    @test nobs(o) == 1000

    # pdf
    rx = o.rngx; ry = o.rngy
    ig = rx.step; jg = ry.step
    ilm = trunc(Int, length(rx) / 2)
    jlm = trunc(Int, length(ry) / 2)
    @test (o.z[ilm, jlm] + o.z[ilm + 1, jlm] + o.z[ilm, jlm + 1] + o.z[ilm + 1, jlm + 1]) / 4 ≈ AverageShiftedHistograms.pdf(o, Float64(rx[ilm] + ig / 2), Float64(ry[jlm] + jg / 2))

    # simpler pdf test
    o2 = ash(1:3, 1:3, rngx=1:3, rngy=1:3, mx=1, my=1)
    @test AverageShiftedHistograms.pdf(o2, 1, 1) == 1 / 3
    @test AverageShiftedHistograms.pdf(o2, 2, 2) == 1 / 3
    @test AverageShiftedHistograms.pdf(o2, 1, 2) == 0

    o = ash([1,2], [1,2])
    @test nout(o) == 0

    mean(o)
    var(o)
    std(o)
    xyz(o)
end

@testset "AshWeighted" begin
    weight_funcs = (weights, aweights, fweights, pweights)

    for f in weight_funcs
        x = randn(10_000)
        o = ash(x, f(ones(21)), rng = -1:0.1:1)
        o2 = ash(x; rng = -1:0.1:1)
        @test o == o2

        y = rand(1000)
        w = f(rand(1:10, 11))
        o = ash(y; rng = 0:0.1:1)
        ow = ash(y, w; rng = 0:0.1:1)
        @test o.counts .* w == ow.counts

        w = f(rand(1:10, 10))
        @test_throws DimensionMismatch ash(y, w; rng = 0:0.1:1)
    end 
end

end #module
