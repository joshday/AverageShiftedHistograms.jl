using AverageShiftedHistograms
using Distributions
using Base.Test

##### Testing probably needs to be redone

#generate data
srand(145)
y1 = rand(Gamma(5,2), 1000)
y2 = y1 + rand(Normal(), 1000) + 5

# Get bins
bin = Bin2(y1, y2, nbin1=100, nbin2=77)

@test bin.n == 1000
@test bin.nout == 0
@test bin.ab1 == ab(y1, 0.1)
@test bin.ab2 == ab(y2, 0.1)
@test bin.nbin1 == 100
@test bin.nbin2 == 77


# Get ash estimate with Gaussian Kernel
ash = Ash2(bin, m1=10, k1=:gaussian, k2=:triweight)

@test ash.m1 == 10
@test ash.m2 == 5
@test ash.b == bin
@test ash.non0 == true
@test length(ash.x) == 100
@test length(ash.y) == 77
@test ash.kernel1 == :gaussian
@test ash.kernel2 == :triweight
