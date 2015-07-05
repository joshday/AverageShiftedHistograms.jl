#===================================================================================#
# Univariate Histograms
#
# Working on my own implementation since both Base.hist and StatsBase.fit(Histogram)
# are both too slow.
#
#===================================================================================#
type UnivariateHistogram
    edges::AbstractVector   # hist(y, edges)[1]
    counts::Array{Int}      # hist(y, edges)[2]
    v::Vector{Float64}      # UnivariateASH estimate
    m::Int                  # smoothing parameter
    kernel::Symbol          # kernel
    n::Int                  # number of observations

    function UnivariateASH(e::AbstractVector, counts::Array{Int}, v::Vector{Float64}, m::Int, kernel::Symbol, n::Int)
        n >= 0 || error("n can't be negative")
        m >= 1 || error("smoothing parameter m must be at least 1")
        kernel ∈ kernellist || error("kernel not recognized")
        length(v) == length(e) - 1 || error("length(v) must be one less than length(hist.edges)")
        new(e, counts, v, m, kernel, n)
    end
end
