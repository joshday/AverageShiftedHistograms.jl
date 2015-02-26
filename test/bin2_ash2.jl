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
@test bin.ab1 == extremastretch(y1, 0.1)
@test bin.ab2 == extremastretch(y2, 0.1)
@test bin.nbin1 == 100
@test bin.nbin2 == 77


# Get ash estimate with Gaussian Kernel
ash = Ash2(bin, m1=10, kernel1=:gaussian, kernel2=:triweight)

@test ash.m1 == 10
@test ash.m2 == 5
@test ash.b == bin
@test ash.non0 == true
@test length(ash.x) == 100
@test length(ash.y) == 77
@test ash.kernel1 == :gaussian
@test ash.kernel2 == :triweight

 

# Update bins with new data
y1_new = rand(Gamma(5,2), 1000)
y2_new = y1_new + rand(Normal(), 1000) + 5
update!(bin, y1_new, y2_new)

@test bin.n == 2000
@test bin.ab1 == extremastretch(y1, 0.1)
@test bin.ab2 == extremastretch(y2, 0.1)
@test bin.nbin1 == 100
@test bin.nbin2 == 77
