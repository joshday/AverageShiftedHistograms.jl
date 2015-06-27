#-------------------------------------------------------# type and constructors
type Bin1{T <: Real}
    v::Vector{Int}        # Counts in each bin
    edges::Vector{T}      # bin edges
    n::Int                # number of observations
end


function Bin1{T <: Real}(a::T, b::T, nbin::Int)
    Bin1(zeros(Int, nbin), linspace(a, b, nbin + 1), 0)
end

function Bin1(n::Int, e::Union(Range, Vector), counts::Vector{Int})
    nbin = length(counts)
    Bin1(counts, [e], n)
end

function Bin1{T <: Real}(y::Vector, a::T, b::T, nbin::Int)
    o = Bin1(a, b, nbin)
    updatebatch!(o, y)
    o
end


#---------------------------------------------------------------------# update!
function updatebatch!(b::Bin1, y::Vector)
    n2 = length(y)
    Base.hist!(b.v, y, b.edges, init = false)
    b.n += length(y)
end


#-----------------------------------------------------------# functions/methods
nout(b::Bin1) = b.n - sum(b.v)
nobs(b::Bin1) = b.n


# TESTING
if false
    x = randn(10_000)
    b1 = AverageShiftedHistograms.Bin1(10_000, hist(x, linspace(-4, 4, 100))...)
    b2 = AverageShiftedHistograms.Bin1(x, -4, 4, 99)
    b1.v - b2.v
    AverageShiftedHistograms.nout(b1)
    AverageShiftedHistograms.nobs(b2)
end
