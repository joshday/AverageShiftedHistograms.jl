module Profiling

using AverageShiftedHistograms, Distributions
# generate data
srand(12345)
y = rand(Gamma(5,2), 10_000_000)
maximum(y)

# Profile Bin1
Profile.clear()
@profile @time for i in 1
    bin = Bin1(y, 0, 50, 100)
end
profile()

end  # module
