using AverageShiftedHistograms, Distributions
# generate data
srand(12345)
y = rand(Gamma(5,2), 100_000)

# Profile Bin1
Profile.clear()
@profile for i in 1:100
    bin = Bin1(y, ab=[0, maximum(y) + 1], nbin=100)
end


# get ash
ash = Ash1(bin, m=5, kernel=:gaussian)
