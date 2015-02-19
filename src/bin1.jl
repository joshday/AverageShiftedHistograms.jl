export Bin1, ab

#-----------------------------------------------------------------------------#
#---------------------------------------------------------------# function: ab
@doc md"""
Returns a length-two vector.  Elements are the extended range of the data
`y` by the factor `c`.  This function is used to generate the end points
for a `Bin1` object.

Usage: `Bin1(mydata, ab=ab(mydata, .2))
""" ->
function extremastretch(y::Vector, c::Float64 = 0.1)
    ymin, ymax = extrema(y)
    r = ymax - ymin
    return [ymin - c*r, ymax + c*r]
end


#-----------------------------------------------------------------------------#
#-----------------------------------------------------------------# type: Bin1
@doc md"""
### Bins for an ASH estimate

| Field              | Description
|:-------------------|:---------------------
| `v::Vector{Int64}` | Bin counts
| `ab::Vector`       | (length two): Bins go from [a, b)
| `nbin::Int64`      | number of bins to use
| `nout::Int64`      | number of observations not captured inside [a, b)
| `n::Int64`         | number of observations used
""" ->
type Bin1
    v::Vector{Int64}        # Counts in each bin
    ab::Vector              # bounds
    nbin::Int64             # number of bins
    nout::Int64             # n outside interval [a, b)
    n::Int64                # number of observations
end


@doc md"""
Contruct a `Bin1` object from a vector of data using `nbin` bins.

The default values for `ab` extend `y`'s minimum/maximum by 10% of the range.
""" ->
function Bin1(y::Vector; ab::Vector = extremastretch(y, 0.1), nbin::Int64=50)
    a, b = ab
    nout::Int64 = 0
    δ = (b - a) / nbin
    n = length(y)
    v = zeros(Int64, nbin)
    for i = 1:n
        k = int((y[i] - a) / δ + 1)
        if k >= 1 && k <= nbin
           v[k] += 1
        else
            nout += 1
        end
    end
    Bin1(v, ab, nbin, nout, length(y))
end


@doc md"""
Update a `Bin1` object with a new vector of data
""" ->
function update!(obj::Bin1, y::Vector)
    newbin = Bin1(y, ab = obj.ab, nbin = obj.nbin)
    obj.v += newbin.v
    obj.nout += newbin.nout
    obj.n += newbin.n
end




