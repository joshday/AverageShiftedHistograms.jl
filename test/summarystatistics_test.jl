

#generate data
srand(12345)
y = rand(Gamma(5,2), 1000)

# Get bins
bin = AverageShiftedHistograms.Bin1(y, ab=[0, maximum(y) + 1], nbin=100)
ash = AverageShiftedHistograms.Ash1(bin, m=10)


