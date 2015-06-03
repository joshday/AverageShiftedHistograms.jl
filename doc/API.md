# AverageShiftedHistograms

## Exported

---

<a id="method__ash1.1" class="lexicon_definition"></a>
#### Ash1(bin::Bin1) [¶](#method__ash1.1)
Contruct an `Ash1` object from a `Bin1` object, smoothing parameter `m`,
and `kernel`.

### `kernel` options

- :uniform
- :triangular
- :epanechnikov
- :biweight
- :triweight
- :tricube
- :gaussian
- :cosine
- :logistic


*source:*
[AverageShiftedHistograms/src/ash1.jl:39](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/ash1.jl#L39)

---

<a id="method__ash2.1" class="lexicon_definition"></a>
#### Ash2(bin::Bin2) [¶](#method__ash2.1)
# Bivariate Average Shifted Histogram

Contruct an `Ash2` object from a `Bin2` object, smoothing parameters `m1`/`m2`,
and kernels `kernel1`/`kernel2`.

### `kernel1`/ `kernel2` options:

- :uniform
- :triangular
- :epanechnikov
- :biweight
- :triweight
- :tricube
- :gaussian
- :cosine
- :logistic


*source:*
[AverageShiftedHistograms/src/ash2.jl:48](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/ash2.jl#L48)

---

<a id="method__bin1.1" class="lexicon_definition"></a>
#### Bin1(y::Array{T, 1}) [¶](#method__bin1.1)
Contruct a `Bin1` object from a vector of data using `nbin` bins.

The default values for `ab` extend `y`'s minimum/maximum by 10% of the range.


*source:*
[AverageShiftedHistograms/src/bin1.jl:40](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin1.jl#L40)

---

<a id="method__bin2.1" class="lexicon_definition"></a>
#### Bin2(y1::Array{T, 1}, y2::Array{T, 1}) [¶](#method__bin2.1)
Contruct a `Bin2` object from two vectors of data using `nbin1` and `nbin2` bins,
respectively.

The default values for `ab1`/`ab2` extend `y1`'s / `y2`'s minimum/maximum by 10%
of the range.


*source:*
[AverageShiftedHistograms/src/bin2.jl:33](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin2.jl#L33)

---

<a id="method__extremastretch.1" class="lexicon_definition"></a>
#### extremastretch(y::Array{T, 1}) [¶](#method__extremastretch.1)
Returns a length-two vector.  Elements are the extended range of the data
`y` by the factor `c`.  This function is used to generate the end points
for a `Bin1` object.

Usage: `Bin1(mydata, ab=extremastretch(mydata, .2))`


*source:*
[AverageShiftedHistograms/src/bin1.jl:9](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin1.jl#L9)

---

<a id="method__extremastretch.2" class="lexicon_definition"></a>
#### extremastretch(y::Array{T, 1}, c::Float64) [¶](#method__extremastretch.2)
Returns a length-two vector.  Elements are the extended range of the data
`y` by the factor `c`.  This function is used to generate the end points
for a `Bin1` object.

Usage: `Bin1(mydata, ab=extremastretch(mydata, .2))`


*source:*
[AverageShiftedHistograms/src/bin1.jl:9](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin1.jl#L9)

---

<a id="method__merge.1" class="lexicon_definition"></a>
#### merge!(b1::Bin1, b2::Bin1) [¶](#method__merge.1)
Merge two `Bin1` objects together.  Overwrite the first argument

*source:*
[AverageShiftedHistograms/src/bin1.jl:71](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin1.jl#L71)

---

<a id="method__merge.2" class="lexicon_definition"></a>
#### merge(b1::Bin1, b2::Bin1) [¶](#method__merge.2)
Merge two `Bin1` objects together

*source:*
[AverageShiftedHistograms/src/bin1.jl:81](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin1.jl#L81)

---

<a id="method__update.1" class="lexicon_definition"></a>
#### update!(obj::Bin2, y1::Array{T, 1}, y2::Array{T, 1}) [¶](#method__update.1)
Update a `Bin2` object with new vectors of data


*source:*
[AverageShiftedHistograms/src/bin2.jl:62](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin2.jl#L62)

---

<a id="method__updatebatch.1" class="lexicon_definition"></a>
#### updatebatch!(b::Bin1, y::Array{T, 1}) [¶](#method__updatebatch.1)
Update a `Bin1` object with a new vector of data


*source:*
[AverageShiftedHistograms/src/bin1.jl:62](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin1.jl#L62)

---

<a id="type__ash1.1" class="lexicon_definition"></a>
#### Ash1 [¶](#type__ash1.1)
Type for storing ash estimate

- `x`:       x values
- `y`:       density at x
- `m`:       smoothing parameter
- `kernel`:  kernel
- `b`:       Bin1 object
- `non0`:    true if nonzero estimate at endpoints


*source:*
[AverageShiftedHistograms/src/ash1.jl:12](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/ash1.jl#L12)

---

<a id="type__ash2.1" class="lexicon_definition"></a>
#### Ash2 [¶](#type__ash2.1)
Type for storing bivariate ash estimate

- `x`:        x values
- `y`:        y values
- `z`:        density at x, y
- `m1`:       smoothing parameter
- `kernel1`:  kernel for x dimension
- `kernel2`:  kernel for y dimension
- `b`:        Bin2 object
- `non0`:     true if nonzero estimate at endpoints


*source:*
[AverageShiftedHistograms/src/ash2.jl:14](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/ash2.jl#L14)

---

<a id="type__bin1.1" class="lexicon_definition"></a>
#### Bin1 [¶](#type__bin1.1)
### Bins for an ASH estimate

- `v`:      bin counts
- `ab`:     length two vector of endpoints
- `nbin`:   number of bins
- `nout`:   number of bins outside [a, b)
- `n`:      number of observations used


*source:*
[AverageShiftedHistograms/src/bin1.jl:26](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin1.jl#L26)

---

<a id="type__bin2.1" class="lexicon_definition"></a>
#### Bin2 [¶](#type__bin2.1)
### Bins for a bivarate ASH estimate

- `v`:        Bin counts
- `ab1`:      (length two): data 1 range: [a, b)
- `ab2`:      (length two): data 2 range: [a, b)
- `nbin1`:    number of bins to use for data 1
- `nbin1`:    number of bins to use for data 2
- `nout`:     number of observations not captured inside [a, b)
- `n`:        number of observations used


*source:*
[AverageShiftedHistograms/src/bin2.jl:13](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/bin2.jl#L13)

## Internal

---

<a id="method__plot.1" class="lexicon_definition"></a>
#### plot(a::Ash1) [¶](#method__plot.1)
Plot an `Ash1` density estimate

*source:*
[AverageShiftedHistograms/src/plot.jl:11](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/plot.jl#L11)

---

<a id="method__plot.2" class="lexicon_definition"></a>
#### plot(a::Ash1, y::Array{T, 1}) [¶](#method__plot.2)
Plot `Ash1` object with data `y`

*source:*
[AverageShiftedHistograms/src/plot.jl:28](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/plot.jl#L28)

---

<a id="method__plot.3" class="lexicon_definition"></a>
#### plot(b::Bin1) [¶](#method__plot.3)
Plot an `Bin1` object

*source:*
[AverageShiftedHistograms/src/plot.jl:3](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/plot.jl#L3)

---

<a id="method__plot.4" class="lexicon_definition"></a>
#### plot(b::Bin1, a::Ash1) [¶](#method__plot.4)
Plot `Bin1` and `Ash1` objects together.  The comparison can be used to check
for oversmoothing.

*source:*
[AverageShiftedHistograms/src/plot.jl:18](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/plot.jl#L18)

---

<a id="method__plot.5" class="lexicon_definition"></a>
#### plot(b::Bin1, a::Ash1, y::Array{T, 1}) [¶](#method__plot.5)
Plot `Bin1`, `Ash1`, and data `y` together

*source:*
[AverageShiftedHistograms/src/plot.jl:36](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/plot.jl#L36)

---

<a id="method__plot.6" class="lexicon_definition"></a>
#### plot(obj::Ash2) [¶](#method__plot.6)
Plot an `Ash2`density estimate

*source:*
[AverageShiftedHistograms/src/plot.jl:49](https://github.com/joshday/AverageShiftedHistograms.jl/tree/848651270ef192ae6f4cc4ce718a25bf96ef64c3/src/plot.jl#L49)

