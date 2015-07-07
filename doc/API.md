# AverageShiftedHistograms

## Exported

---

<a id="function__ash.1" class="lexicon_definition"></a>
#### ash! [¶](#function__ash.1)
Create the ASH estimate and optionally change smoothing parameter(s) and kernel(s)


*source:*
[AverageShiftedHistograms/src/univariate.jl:92](https://github.com/joshday/AverageShiftedHistograms.jl/tree/15ceb3473aba47304e9b6091d5c0f660dd3b35a8/src/univariate.jl#L92)

---

<a id="method__fit.1" class="lexicon_definition"></a>
#### fit(::Type{UnivariateASH}, y::Array{Float64, 1}, a, b, nbin, m::Int64) [¶](#method__fit.1)
Get ASH estimate specifying the endpoints and nbins

*source:*
[AverageShiftedHistograms/src/univariate.jl:83](https://github.com/joshday/AverageShiftedHistograms.jl/tree/15ceb3473aba47304e9b6091d5c0f660dd3b35a8/src/univariate.jl#L83)

---

<a id="method__fit.2" class="lexicon_definition"></a>
#### fit(::Type{UnivariateASH}, y::Array{Float64, 1}, a, b, nbin, m::Int64, kernel::Symbol) [¶](#method__fit.2)
Get ASH estimate specifying the endpoints and nbins

*source:*
[AverageShiftedHistograms/src/univariate.jl:83](https://github.com/joshday/AverageShiftedHistograms.jl/tree/15ceb3473aba47304e9b6091d5c0f660dd3b35a8/src/univariate.jl#L83)

---

<a id="method__fit.3" class="lexicon_definition"></a>
#### fit(::Type{UnivariateASH}, y::Array{Float64, 1}, edg::Range{T}, m::Int64) [¶](#method__fit.3)
Get ASH estimate specifying the bin edges (nbins = length(edg) - 1)

*source:*
[AverageShiftedHistograms/src/univariate.jl:76](https://github.com/joshday/AverageShiftedHistograms.jl/tree/15ceb3473aba47304e9b6091d5c0f660dd3b35a8/src/univariate.jl#L76)

---

<a id="method__fit.4" class="lexicon_definition"></a>
#### fit(::Type{UnivariateASH}, y::Array{Float64, 1}, edg::Range{T}, m::Int64, kernel::Symbol) [¶](#method__fit.4)
Get ASH estimate specifying the bin edges (nbins = length(edg) - 1)

*source:*
[AverageShiftedHistograms/src/univariate.jl:76](https://github.com/joshday/AverageShiftedHistograms.jl/tree/15ceb3473aba47304e9b6091d5c0f660dd3b35a8/src/univariate.jl#L76)

---

<a id="method__nout.1" class="lexicon_definition"></a>
#### nout(o::UnivariateASH) [¶](#method__nout.1)
return the number of observations outside the endpoints of the histogram bins

*source:*
[AverageShiftedHistograms/src/univariate.jl:133](https://github.com/joshday/AverageShiftedHistograms.jl/tree/15ceb3473aba47304e9b6091d5c0f660dd3b35a8/src/univariate.jl#L133)

---

<a id="method__update.1" class="lexicon_definition"></a>
#### update!(o::UnivariateASH, y::Array{Float64, 1}) [¶](#method__update.1)
Update UnivariateASH with new data and optional new smoothing parameter/kernel

*source:*
[AverageShiftedHistograms/src/univariate.jl:112](https://github.com/joshday/AverageShiftedHistograms.jl/tree/15ceb3473aba47304e9b6091d5c0f660dd3b35a8/src/univariate.jl#L112)

---

<a id="method__update.2" class="lexicon_definition"></a>
#### update!(o::UnivariateASH, y::Array{Float64, 1}, m::Int64) [¶](#method__update.2)
Update UnivariateASH with new data and optional new smoothing parameter/kernel

*source:*
[AverageShiftedHistograms/src/univariate.jl:112](https://github.com/joshday/AverageShiftedHistograms.jl/tree/15ceb3473aba47304e9b6091d5c0f660dd3b35a8/src/univariate.jl#L112)

---

<a id="method__update.3" class="lexicon_definition"></a>
#### update!(o::UnivariateASH, y::Array{Float64, 1}, m::Int64, kernel::Symbol) [¶](#method__update.3)
Update UnivariateASH with new data and optional new smoothing parameter/kernel

*source:*
[AverageShiftedHistograms/src/univariate.jl:112](https://github.com/joshday/AverageShiftedHistograms.jl/tree/15ceb3473aba47304e9b6091d5c0f660dd3b35a8/src/univariate.jl#L112)

