using AverageShiftedHistograms
using Distributions
using Base.Test


#generate data
srand(12345)
y = rand(Gamma(5,2), 1000)

# Get bins
bin = Bin1(y, ab=[0, maximum(y) + 1], nbin=100)

@test bin.n == 1000
@test bin.nout == 0

@test bin.ab == [0, maximum(y) + 1]
@test bin.nbin == 100


# Get ash estimate with Gaussian Kernel
ash = Ash1(bin, m=5, kernel=:gaussian)

@test ash.m == 5
@test ash.b == bin
@test ash.non0 == true
@test length(ash.x) == length(ash.y)
@test ash.kernel == :gaussian


# Update bins
y2 = rand(Gamma(5,2), 1001)
update!(bin, y2)

@test bin.n == 2001
@test bin.ab == [0, maximum(y) + 1]
@test bin.nbin == 100

