module KernelsTest

using AverageShiftedHistograms, FactCheck

facts("Kernels") do
    context("test for symmetry") do
        for kernel in keys(AverageShiftedHistograms.kernels)
            for u in [0.0, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1.0, 10.0]
                @fact kernel(-u) --> roughly(kernel(u))
            end
        end
    end
end

end # module
