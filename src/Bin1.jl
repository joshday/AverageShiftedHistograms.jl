
#---------------------------------------------------------------# extremastretch
"""
Returns a length-two vector.  Elements are the extended range of the data
`y` by the factor `c`.  This function is used to generate the end points
for a `Bin1` object.
Usage: `Bin1(mydata, ab=extremastretch(mydata, .2))`
"""
function extremastretch(y::Vector, c::Float64 = 0.1)
    ymin, ymax = extrema(y)
    r = ymax - ymin
    return [ymin - c*r, ymax + c*r]
end


#------------------------------------------------------------------------# Bin1
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
    @compat δ = Float64((b - a) / nbin)
    n::Int = length(y)
    v::Vector{Int} = zeros(Int, nbin)

    for i = 1:n
        ki::Int = floor(Int, (y[i] - a) / δ + 1)
        (ki >= 1 && ki <= nbin) ? v[ki] += 1 : nout += 1
    end

    Bin1(v, ab, nbin, nout, length(y))
end





"""
Update a `Bin1` object with a new vector of data
"""
function updatebatch!(b::Bin1, y::Vector)
    b2 = Bin1(y, ab = b.ab, nbin = b.nbin)
    merge!(b, b2)
end

#------------------------------------------------------------------------# Base
copy(b::Bin1) = Bin1(b.v, b.ab, b.nbin, b.nout, b.n)

"Merge two `Bin1` objects together.  Overwrite the first argument"
function merge!(b1::Bin1, b2::Bin1)
    all(b1.ab .== b2.ab) || error("objects have different endpoints")
    b1.nbin == b2.nbin || error("objects have different number of bins")

    b1.nout += b2.nout
    b1.n += b2.n
    b1.v += b2.v
end

"Merge two `Bin1` objects together"
merge(b1::Bin1, b2::Bin1) = merge!(copy(b1), b2)
