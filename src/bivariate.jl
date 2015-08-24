# Bivariate Average Shifted Histogram
#
# Pseudocode available in http://www.stat.rice.edu/%7Escottdw/stat550/HW/hw4/c05.pdf

type BivariateASH
    rngx::FloatRange{Float64}   # range in x direction
    rngy::FloatRange{Float64}   # range in y direction
    v::Matrix{Int}              # bin counts
    z::MatF                     # ash estimate
    mx::Int                     # smoothing parameter: x direction
    my::Int                     # smoothing parameter: y direction
    kernelx::Symbol             # kernel: x direction
    kernely::Symbol             # smoothing parameter: x direction
    n::Int
    function BivariateASH(rngx::FloatRange{Float64}, mx::Int, kernelx::Symbol, rngy::FloatRange{Float64}, my::Int, kernely::Symbol)
        lx = length(rngx)
        ly = length(rngy)
        lx >= 2 || error("need at least 2 bins in x direction!")
        ly >= 2 || error("need at least 2 bins in y direction!")
        mx >= 0 || error("smoothing parameter mx must be nonnegative")
        my >= 0 || error("smoothing parameter my must be nonnegative")
        kernelx in kernellist || error("kernelx not recognized")
        kernely in kernellist || error("kernely not recognized")
        new(rngx, rngy, zeros(Int, ly, lx), zeros(ly, lx), mx, my, kernelx, kernely, 0.0)
    end
end


function ash(x::VecF, y::VecF, rngx::Range, rngy::Range;
             mx::Int = 5, my::Int = 5, kernelx::Symbol = :biweight, kernely::Symbol = :biweight)
     @compat myrngx = FloatRange(Float64(rngx.start), Float64(rngx.step), Float64(rngx.len), Float64(rngx.divisor))
     @compat myrngy = FloatRange(Float64(rngy.start), Float64(rngy.step), Float64(rngy.len), Float64(rngy.divisor))
     o = BivariateASH(myrngx, mx, kernelx, myrngy, my, kernely)
     update!(o, x, y)
     update!(o)
     o
 end


function ash(x::VecF, y::VecF;
             nbinx::Int = 1000, nbiny::Int = 1000, r::Real = 0.2, mx = 5, my = 5, kernelx = :biweight, kernely = :biweight)
    r > 0 || error("r must be positive")
    ax, bx = extrema(x)
    ay, by = extrema(y)
    rngx = bx - ax
    rngy = by - ay
    ax -= rngx * r
    bx += rngx * r
    ay -= rngy * r
    by += rngy * r
    stepx = (bx - ax) / nbinx
    stepy = (by - ay) / nbiny
    ash(x, y, ax:stepx:bx, ay:stepy:by, mx = mx, my = my, kernelx = kernelx, kernely = kernely)
end


function updatebin!(o::BivariateASH, x::VecF, y::VecF)
    length(x) == length(y) || error("data vectors must have equal length")
    δx = o.rngx.step / o.rngx.divisor
    δy = o.rngy.step / o.rngy.divisor
    ax = o.rngx[1]
    ay = o.rngy[1]
    nbinx = length(o.rngx)
    nbiny = length(o.rngy)

    for i = 1:length(y)
        kx = floor(Int, (x[i] - ax) / δx + 1.5)
        ky = floor(Int, (y[i] - ay) / δy + 1.5)
        if 1 <= kx <= nbinx && 1 <= ky <= nbiny
            o.v[ky, kx] += 1
        end
    end
    o.n += length(y)
end

function update!(o::BivariateASH, x::VecF, y::VecF)
    updatebin!(o, x, y)
    update!(o)
    o
end

function update!(o::BivariateASH, mx = o.mx, my = o.my, kernelx = o.kernelx, kernely = o.kernely; warnout = true)
    o.mx = mx
    o.my = my
    o.kernelx = kernelx
    o.kernely = kernely

    w = zeros(2 * my - 1, 2 * mx - 1)
    for i = (1 - my):(my - 1), j = (1 - mx):(mx - 1)
        w[i + my, j + mx] = kernels[kernely](i / my) * kernels[kernelx](i / mx)
    end

    δx = o.rngx.step / o.rngx.divisor
    δy = o.rngy.step / o.rngy.divisor

    nbinx = length(o.rngx)
    nbiny = length(o.rngy)
    for k = 1:nbiny
       for l = 1:nbinx
           if o.v[k, l] == 0
                l += 1
            else
                for i = max(1, k - my + 1):min(nbiny, k + my - 1)
                    for j = max(1, l - mx + 1):min(nbinx, l + mx - 1)
                        o.z[i, j] += o.v[k, l] * w[my + i - k, mx + j - l]
                    end
                end
            end
        end
    end

    o.z /= sum(o.z) * δx * δy # make the density integrate to 1

    if any(o.z[1, :] .!= 0) || any(o.z[:, 1] .!= 0) || any(o.z[:, end] .!= 0) || any(o.z[end, :] .!= 0)
        warnout && warn("nonzero density outside of bounds")
    end
    o
end

function Base.show(io::IO, o::BivariateASH)
    println(io, typeof(o))
    println(io, "*  kernel: ", (o.kernelx, o.kernely))
    println(io, "*       m: ", (o.mx, o.my))
    println(io, "*   edges: ", (o.rngx, o.rngy))
    println(io, "*    nobs: ", nobs(o))
end

nobs(o::BivariateASH) = o.n
nout(o::BivariateASH) = nobs(o) - sum(o.v)
xyz(o::BivariateASH) = (collect(o.rngx), collect(o.rngy), copy(o.z))
function mean(o::BivariateASH)
    meanx = mean(collect(o.rngx), WeightVec(vec(sum(o.z, 1))))
    meany = mean(collect(o.rngy), WeightVec(vec(sum(o.z, 2))))
    [meanx; meany]
end
function var(o::BivariateASH)
    varx = var(collect(o.rngx), WeightVec(vec(sum(o.z, 1))))
    vary = var(collect(o.rngy), WeightVec(vec(sum(o.z, 2))))
    [varx; vary]
end
std(o::BivariateASH) = sqrt(var(o))



# o = AverageShiftedHistograms.BivariateASH(randn(1000), randn(1000), -4:.1:4, -4:.1:4)
