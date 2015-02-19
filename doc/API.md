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
[AverageShiftedHistograms/src/ash1.jl:45](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/ash1.jl#L45)

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
[AverageShiftedHistograms/src/ash2.jl:54](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/ash2.jl#L54)

---

#### Bin1(y::Array{T, 1})
Contruct a `Bin1` object from a vector of data using `nbin` bins.

The default values for `ab` extend `y`'s minimum/maximum by 10% of the range.


**source:**
[AverageShiftedHistograms/src/bin1.jl:45](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/bin1.jl#L45)

---

#### Bin2(y1::Array{T, 1}, y2::Array{T, 1})
Contruct a `Bin2` object from two vectors of data using `nbin1` and `nbin2` bins,
respectively.

The default values for `ab1`/`ab2` extend `y1`'s / `y2`'s minimum/maximum by 10%
of the range.


**source:**
[AverageShiftedHistograms/src/bin2.jl:37](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/bin2.jl#L37)

---

#### Ash1
Type for storing ash estimate

| Field           | Description
|:----------------|:------------------------------
| `x::Vector`     | x values
| `y::Vector`     | density at x
| `m::Int64`      | smoothing parameter
| `kernel::Symbol | kernel
| `b`             | Bin1 object
| `non0::Bool`    | true if nonzero estimate at endpoints


**source:**
[AverageShiftedHistograms/src/ash1.jl:16](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/ash1.jl#L16)

---

#### Ash2
Type for storing bivariate ash estimate

| Field                      | Description
|:---------------------------|:------------------------------
| `x::Vector`                | x values
| `y::Vector`                | y values
| `z::Matrix`                | density at x, y
| `m1::Int64`                | smoothing parameter
| `kernel1::Symbol`          | kernel for x dimension
| `kernel2::Symbol`          | kernel for y dimension
| `b`                        | Bin2 object
| `non0::Bool`               | true if nonzero estimate at endpoints


**source:**
[AverageShiftedHistograms/src/ash2.jl:19](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/ash2.jl#L19)

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
[AverageShiftedHistograms/src/bin1.jl:31](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/bin1.jl#L31)

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
[AverageShiftedHistograms/src/bin2.jl:17](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/bin2.jl#L17)

## Internal
---

#### extremastretch(y::Array{T, 1})
Returns a length-two vector.  Elements are the extended range of the data
`y` by the factor `c`.  This function is used to generate the end points
for a `Bin1` object.

Usage: `Bin1(mydata, ab=ab(mydata, .2))


**source:**
[AverageShiftedHistograms/src/bin1.jl:11](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/bin1.jl#L11)

---

#### extremastretch(y::Array{T, 1}, c::Float64)
Returns a length-two vector.  Elements are the extended range of the data
`y` by the factor `c`.  This function is used to generate the end points
for a `Bin1` object.

Usage: `Bin1(mydata, ab=ab(mydata, .2))


**source:**
[AverageShiftedHistograms/src/bin1.jl:11](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/bin1.jl#L11)

---

#### plot(obj::Ash1)
Plot an `Ash1`density estimate

**source:**
[AverageShiftedHistograms/src/plot.jl:1](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/plot.jl#L1)

---

#### plot(obj::Ash2)
Plot an `Ash2`density estimate

**source:**
[AverageShiftedHistograms/src/plot.jl:16](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/plot.jl#L16)

---

#### update!(obj::Bin1, y::Array{T, 1})
Update a `Bin1` object with a new vector of data


**source:**
[AverageShiftedHistograms/src/bin1.jl:66](https://github.com/joshday/AverageShiftedHistograms.jl/tree/81ae86318024b7d7538114538506eee017add6ec/src/bin1.jl#L66)


