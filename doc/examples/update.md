
# Univariate `Update!`

````julia
using AverageShiftedHistograms
using Gadfly
````





### First-batch bins and ash estimate
````julia
x = randn(100)
bin = Bin1(x, ab=[-5, 5])
ash = Ash1(bin)
plot(ash, x)
````


![](figures/update_2_1.png)



### Update bins with many batches
````julia
for i =1:100000
	update!(bin, randn(100))
end

ash = Ash1(bin, m=2)
plot(ash)
````


![](figures/update_3_1.png)
