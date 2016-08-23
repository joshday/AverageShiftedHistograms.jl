module Tests
using AverageShiftedHistograms

# necessary to support 0.4 and 0.5
if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end


@testset "Kernels" begin
    for kernel in [biweight, cosine, epanechnikov, triangular, tricube, triweight,
                   uniform, gaussian, logistic]
        for u in [0.0, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1.0, 10.0]
            @test kernel(-u) ≈ kernel(u)
        end
    end
end

@testset "Ash" begin
    y = randn(10_000)
    o = ash(y; warnout = false)
    show(o)

end

end #module
