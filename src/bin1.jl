#---------------------------------------------------------------# extremastretch
"""
Returns a length-two vector.  Elements are the extended range of the data
`y` by the factor `c`.  This function is used to generate the end points
for a `Bin1` object.

Usage: `Bin1(mydata, ab=extremastretch(mydata, .2))
"""
function extremastretch(y::Vector, c::Float64 = 0.1)
    ymin, ymax = extrema(y)
    r = ymax - ymin
    return [ymin - c*r, ymax + c*r]
end


#-----------------------------------------------------------------# type: Bin1
"""
### Bins for an ASH estimate

- `v`:      bin counts
- `ab`:     length two vector of endpoints
- `nbin`:   number of bins
- `nout`:   number of bins outside [a, b)
- `n`:      number of observations used
"""
type Bin1
    v::Vector{Int}        # Counts in each bin
    ab::Vector            # bounds
    nbin::Int             # number of bins
    nout::Int             # n outside interval [a, b)
    n::Int                # number of observations
end


"""
Contruct a `Bin1` object from a vector of data using `nbin` bins.

The default values for `ab` extend `y`'s minimum/maximum by 10% of the range.
"""
function Bin1(y::Vector; ab::Vector = extremastretch(y, 0.1), nbin::Int=50)
    a, b = ab
    nout::Int = 0
    δ = (b - a) / nbin
    n::Int = length(y)
    v::Vector{Int} = zeros(Int, nbin)
#     @compat k::Vector{Int} = Int64(floor((y - a) / δ + 1))

    for i = 1:n
        @compat ki::Int = Int64(floor((y[i] - a) / δ + 1))
        ki >= 1 && ki <= nbin ? v[ki] += 1 : nout += 1
    end

    Bin1(v, ab, nbin, nout, length(y))
end


# Moved to OnlineStats.jl
# """
# Update a `Bin1` object with a new vector of data
# """
# function update!(obj::Bin1, y::Vector)
#     newbin = Bin1(y, ab = obj.ab, nbin = obj.nbin)
#     obj.v += newbin.v
#     obj.nout += newbin.nout
#     obj.n += newbin.n
# end




