## Univariate Usage
* 1) Create bins with `Bin1`
* 2) Create ASH estimate with `Ash1`
* 3) Take a look at the estimated density:	

```
bins = Bin1(y, ab = [lowerbound, upperbound], nbin=50) 
ash = Ash1(bins, m=5, kernel=:epanechnikov)
Gadfly.plot(bins)
Gadfly.plot(ash)
Gadfly.plot(ash, y)
Gadfly.plot(bins, ash, y)
```

Plotting methods create a graph of some combination of points (`bins`), line (`ash`), and histogram (`y`).  

`[lowerbound, upperbound]` can be set with `extremastretch(y, c)` which extends the extrema of `y` by `c` * `range(y)`



#### Univariate Details
##### `Bin1`

| Argument     | Description
|:-------------|----------------------------------
| `y::Vector`  | data
| `ab::Vector` | (length two) specifying endpoints 
| `nbin::Int64`| number of bins to use

##### `Ash1`
	
| Argument         | Description
|:-----------------|--------------------------------
| `bin::Bin1`      | data
| `m::Int64  `     | smoothing parameter
| `kernel::Symbol` |kernel to use	 
		
	

----
----
-----


## Bivariate Usage
* 1) Create bins with `Bin2`
* 2) Create ASH estimate with `Ash2`
* 3) Take a look at the estimated density:

```
bins = Bin2(y1, y2) 

ash = Ash2(bins)

Gadfly.plot(ash)
```

Plot is a contour plot for now.  When 3D plots appear in Gadfly, more options will be made available.

#### Bivariate Details
##### `Bin2`

| Argument     | Description
|:-------------|----------------------------------
| `y1::Vector` | data vector 1
| `y2::Vector` | data vector 2
| `ab1::Vector`| endpoints for y1
| `ab2::Vector`| endpoints for y2
|`nbin1::Int64`| number of bins to use for y1
|`nbin1::Int64`| number of bins to use for y2

##### `Ash2`
	
| Argument          | Description
|:------------------|--------------------------------
| `bin::Bin2`       | data
| `m1::Int64`       | smoothing parameter for y1
| `m2::Int64`       | smoothing parameter for y2
| `kernel1::Symbol` | kernel associated with y1
| `kernel2::Symbol` | kernel associated with y2


