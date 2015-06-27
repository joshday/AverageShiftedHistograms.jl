module Profiling
using AverageShiftedHistograms, Distributions

srand(12345)
y = rand(Gamma(5,2), 10_000_000)
maximum(y)

# Profile Bin1
Profile.clear()
b = Bin1(y, 0, 50, 1000)
a = Ash1(b, 10)

end  # module
