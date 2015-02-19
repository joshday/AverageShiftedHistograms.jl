# AverageShiftedHistograms

## Exported
---

#### Ash1(bin::Bin1)
# Average Shifted Histogram

Contruct an `Ash1` object from a `Bin1` object, smoothing parameter `m`,
and kernel `kern`.

### `kern` options

- :uniform
- :triangular
- :epanechnikov
- :biweight
- :triweight
- :tricube
- :gaussian
- :cosine
- :logistic


**source:**
[AverageShiftedHistograms/src/ash1.jl:45](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/ash1.jl#L45)

---

#### Ash2(bin::Bin2)
# Bivariate Average Shifted Histogram

Contruct an `Ash2` object from a `Bin2` object, smoothing parameters `m1`/`m2`,
and kernels `k1`/`k2`.

### `k1`/ `k2` options:

- :uniform
- :triangular
- :epanechnikov
- :biweight
- :triweight
- :tricube
- :gaussian
- :cosine
- :logistic



**source:**
[AverageShiftedHistograms/src/ash2.jl:53](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/ash2.jl#L53)

---

#### Bin1(y::Array{T, 1})
Contruct a `Bin1` object from a vector of data using `nbin` bins.

The default values for `ab` extend `y`'s minimum/maximum by 10% of the range.


**source:**
[AverageShiftedHistograms/src/bin1.jl:29](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/bin1.jl#L29)

---

#### Bin2(y1::Array{T, 1}, y2::Array{T, 1})
Contruct a `Bin2` object from two vectors of data using `nbin1` and `nbin2` bins,
respectively.

The default values for `ab1`/`ab2` extend `y1`'s / `y2`'s minimum/maximum by 10%
of the range.


**source:**
[AverageShiftedHistograms/src/bin2.jl:37](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/bin2.jl#L37)

---

#### ab(y::Array{T, 1}, c::Float64)
Returns a length-two vector.  Elements are the extended range of the data
`y` by the factor `c`.  This function is used to generate the end points
for a `Bin1` object.

Usage: `Bin1(mydata, ab=ab(mydata, .2))


**source:**
[AverageShiftedHistograms/src/bin1.jl:68](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/bin1.jl#L68)

---

#### Ash1
Type for storing ash estimate

| Field        | Description
|:-------------|:------------------------------
| `x::Vector`  | x values
| `y::Vector`  | density at x
| `m::Int64`   | smoothing parameter
| `k::Symbol   | kernel
| `b`          | Bin1 object
| `non0::Bool` | true if nonzero estimate at endpoints


**source:**
[AverageShiftedHistograms/src/ash1.jl:16](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/ash1.jl#L16)

---

#### Ash2
Type for storing bivariate ash estimate

| Field                      | Description
|:---------------------------|:------------------------------
| `x::Vector`                | x values
| `y::Vector`                | y values
| `z::Matrix`                | density at x, y
| `m1::Int64`                | smoothing parameter
| `k::Symbol                 | kernel
| `b`                        | Bin1 object
| `non0::Bool`               | true if nonzero estimate at endpoints


**source:**
[AverageShiftedHistograms/src/ash2.jl:18](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/ash2.jl#L18)

---

#### Bin1
### Bins for an ASH estimate

| Field              | Description
|:-------------------|:---------------------
| `v::Vector{Int64}` | Bin counts
| `ab::Vector`       | (length two): Bins go from [a, b)
| `nbin::Int64`      | number of bins to use
| `nout::Int64`      | number of observations not captured inside [a, b)
| `n::Int64`         | number of observations used


**source:**
[AverageShiftedHistograms/src/bin1.jl:15](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/bin1.jl#L15)

---

#### Bin2
### Bins for a bivarate ASH estimate

| Field              | Description
|:-------------------|:---------------------
| `v::Vector{Int64}` | Bin counts
| `ab1::Vector`      | (length two): data 1 range: [a, b)
| `ab2::Vector`      | (length two): data 2 range: [a, b)
| `nbin1::Int64`     | number of bins to use for data 1
| `nbin1::Int64`     | number of bins to use for data 2
| `nout::Int64`      | number of observations not captured inside [a, b)
| `n::Int64`         | number of observations used


**source:**
[AverageShiftedHistograms/src/bin2.jl:17](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/bin2.jl#L17)

## Internal
---

#### plot(obj::Ash1)
Plot an `Ash1`density estimate

**source:**
[AverageShiftedHistograms/src/plot.jl:1](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/plot.jl#L1)

---

#### plot(obj::Ash2)
Plot an `Ash2`density estimate

**source:**
[AverageShiftedHistograms/src/plot.jl:16](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/plot.jl#L16)

---

#### update!(obj::Bin1, y::Array{T, 1})
Update a `Bin1` object with a new vector of data


**source:**
[AverageShiftedHistograms/src/bin1.jl:50](https://github.com/joshday/AverageShiftedHistograms.jl/tree/028aebefd029926589d6cfd78a3bffab105a4839/src/bin1.jl#L50)


