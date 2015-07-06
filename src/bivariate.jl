# Bivariate Average Shifted Histogram
#
# Pseudocode available in http://www.stat.rice.edu/%7Escottdw/stat550/HW/hw4/c05.pdf

type Bin2
    v::Matrix{Int}                  # Counts in each bin
    dimx::(Float64, Float64, Int)   # (a, b, nbin)
    dimy::(Float64, Float64, Int)   # (a, b, nbin)
    n::Int                          # number of observations

    function Bin2(v::Matrix{Int},
                  dimx::(Float64, Float64, Int),
                  dimy::(Float64, Float64, Int),
                  n::Int)
        dimx[1] < dimx[2] || error("lower bound must be smaller than upper bound (x)")
        dimx[1] < dimy[2] || error("lower bound must be smaller than upper bound (y)")
        dimx[3] > 1 && dimy[3] > 1 || error("number of bins must be at least 2 for both dimensions")
        n >= 0 || error("n must be nonnegative")
        new(v, dimx, dimy, n)
    end
end

function Bin2(a1, b1, nbin1, a2, b2, nbin2)
    @compat dimx = (Float64(a1), Float64(b1), nbin1)
    @compat dimy = (Float64(a2), Float64(b2), nbin2)
    Bin2(zeros(Int, nbin1, nbin2), dimx, dimy, 0)
end

function Bin2(xedg::Range, yedg::Range)
    Bin2(minimum(xedg), maximum(xedg), length(xedg) - 1,
         minimum(yedg), maximum(yedg), length(yedg) - 1)
end

function Bin2(x::VecF, y::VecF, a1, b1, nbin1, a2, b2, nbin2)
    o = Bin2(a1, b1, nbin1, a2, b2, nbin2)
    update!(o, x, y)
    o
end

function Bin2(x::VecF, y::VecF, xedg::Range, yedg::Range)
    o = Bin2(xedg, yedg)
    update!(o, x, y)
    o
end


function update!(o::Bin2, x::Vector{Float64}, y::Vector{Float64})
    length(x) == length(y) || error("data vectors must have equal length")
    δ1 = (o.dimx[2] - o.dimx[1]) / o.dimx[3]
    δ2 = (o.dimy[2] - o.dimy[1]) / o.dimy[3]

    for i = 1:length(y)
        @inbounds k1 = floor(Int, 1 + (x[i] - o.dimx[1]) / δ1)
        @inbounds k2 = floor(Int, 1 + (y[i] - o.dimy[1]) / δ2)
        if 1 <= k1 <= o.dimx[3] && 1 <= k2 <= o.dimy[3]
            @inbounds o.v[k1, k2] += 1
        end
    end
end



#----------------------------------------------------------------------# BivariateASH
type BivariateASH
    x::VecF
    y::VecF
    z::MatF         # density at (x, y)
    mx::Int64       # smoothing parameter in x direction
    my::Int64       # smoothing parameter in y direction
    kernelx::Symbol # kernel in x direction
    kernely::Symbol # kernel in y direction
    bin2::Bin2      # Bin2 object


    function BivariateASH(o::Bin2, mx, my, kernelx = :biweight, kernely = :biweight, warnout::Bool = true)
        mx >= 0 && my >= 0 || error("smoothing parameters must be nonnegative")
        kernelx in kernellist || error("kernelx not recognized")
        kernely in kernellist || error("kernely not recognized")

        δx = (o.dimx[2] - o.dimx[1]) / o.dimx[3]
        δy = (o.dimy[2] - o.dimy[1]) / o.dimy[3]
        x, y = [1:o.dimx[3]], [1:o.dimy[3]]
        x = o.dimx[1] + (x - 0.5) * δx
        y = o.dimy[1] + (y - 0.5) * δy
        a = new(x, y, zeros(o.dimx[3], o.dimy[3]), mx, my, kernelx, kernely, o)
        ash!(a)
        a
    end

end

function fit(::Type{BivariateASH}, x, y, xrange::Range, yrange::Range, mx, my, kernelx = :biweight, kernely = :biweight; warnout::Bool = true)
    b = Bin2(x, y, xrange, yrange)
    o = BivariateASH(b, mx, my, kernelx, kernely, warnout)
end

function ash!(o::BivariateASH, mx = o.mx, my = o.my, kernelx = o.kernelx, kernely = o.kernely; warnout = true)
    o.mx = mx
    o.my = my
    o.kernelx = kernelx
    o.kernely = kernely

    w = zeros(2 * my - 1, 2 * mx - 1)
    for i = (1 - my):(my - 1), j = (1 - mx):(mx - 1)
        w[i + my, j + mx] = kernels[kernely](i / my) * kernels[kernelx](i / mx)
        # w[i + my, j + mx] = kernels[kernely](i) * kernels[kernelx](i)
    end

    δx = (o.bin2.dimx[2] - o.bin2.dimx[1]) / o.bin2.dimx[3] #(b1 - a1) / nbin1
    δy = (o.bin2.dimy[2] - o.bin2.dimy[1]) / o.bin2.dimy[3]
    hx = δx * mx
    hy = δy * my

    nbinx = o.bin2.dimx[3]
    nbiny = o.bin2.dimy[3]
    for k = 1:nbiny
       for l = 1:nbinx
           if o.bin2.v[k, l] == 0
                l += 1
            else
                for i = max(1, k - my + 1):min(nbiny, k + my - 1)
                    for j = max(1, l - mx + 1):min(nbinx, l + mx - 1)
                        o.z[i, j] += o.bin2.v[k, l] * w[my + i - k, mx + j - l]
                    end
                end
            end
        end
    end

    o.z /= sum(o.z) * δx * δy # make the density integrate to 1

    if any(o.z[1, :]!=0) || any(o.z[:, 1]!=0) || any(o.z[:, end]!=0) || any(o.z[end, :]!=0)
        warn("nonzero density outside of bounds")
    end
end

nobs(o::Bin2) = o.n
nobs(o::BivariateASH) = nobs(o.bin2)
