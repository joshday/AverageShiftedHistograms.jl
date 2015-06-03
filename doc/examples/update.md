
# Univariate `Update!`

````julia
using AverageShiftedHistograms
using Distributions
using Gadfly
````





### First-batch bins and ash estimate
````julia
x = randn(100)
bin = Bin1(x, ab=[-5, 5])
ash = Ash1(bin)
plot(bin, ash)
````


![](figures/update_2_1.png)



### Update bins with many batches
````julia
for i = 1:100000
	updatebatch!(bin, randn(100))
end

ash = Ash1(bin, m=2)
plot(bin, ash)
````


![](figures/update_3_1.png)



````julia
julia> mean(ash)
0.0002338729164677554

julia> var(ash)
1.0239932546395352

julia> quantile(ash, [.25, .5, .75])
3-element Array{Any,1}:
 -0.784629 
 -0.0998345
  0.584876 

julia> 
# true quantiles:
quantile(Normal(), [.25, .5, .75])
3-element Array{Float64,1}:
 -0.67449
  0.0    
  0.67449

````




