#------------------------------------------------------------------------# Bin2
"""
### Bins for a bivarate ASH estimate

- `v`:        Bin counts
- `ab1`:      (length two): data 1 range: [a, b)
- `ab2`:      (length two): data 2 range: [a, b)
- `nbin1`:    number of bins to use for data 1
- `nbin1`:    number of bins to use for data 2
- `nout`:     number of observations not captured inside [a, b)
- `n`:        number of observations used
"""
type Bin2
    v::Matrix{Int}        # Counts in each bin
    ab1::Vector           # bounds for first data vector
    ab2::Vector           # bounds for second data vector
    nbin1::Int            # number of bins
    nbin2::Int            # number of bins
    nout::Int             # n outside interval [a, b)
    n::Int                # number of observations
end




"""
Contruct a `Bin2` object from two vectors of data using `nbin1` and `nbin2` bins,
respectively.

The default values for `ab1`/`ab2` extend `y1`'s / `y2`'s minimum/maximum by 10%
of the range.
"""
function Bin2(y1::Vector,
              y2::Vector;
              ab1::Vector = extremastretch(y1, 0.1),
              ab2::Vector = extremastretch(y2, 0.1),
              nbin1::Int64 = 50,
              nbin2::Int64 = 50)
    a1, b1 = ab1
    a2, b2 = ab2
    δ1 = (b1 - a1) / nbin1
    δ2 = (b2 - a2) / nbin2
    v = zeros(Int64, nbin1, nbin2)
    nout = 0

    for i = 1:length(y1)
        k1 = floor(Int, 1 + (y1[i] - a1) / δ1)
        k2 = floor(Int, 1 + (y2[i] - a2) / δ2)
        if k1 >= 1 && k1 <= nbin1 && k2 >= 1 && k2 <= nbin2
            v[k1, k2] += 1
        else
            nout += 1
        end
    end
    Bin2(v, ab1, ab2, nbin1, nbin2, 0, length(y1))
end


"""
Update a `Bin2` object with new vectors of data
"""
function update!(obj::Bin2, y1::Vector, y2::Vector)
    newbin = Bin2(y1, y2,
                  ab1 = obj.ab1, ab2 = obj.ab2,
                  nbin1 = obj.nbin1, nbin2 = obj.nbin2)
    obj.v += newbin.v
    obj.nout += newbin.nout
    obj.n += newbin.n
end
