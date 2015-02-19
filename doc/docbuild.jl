# To build docs, run include("doc/docbuild.jl") from repository root folder

using Lexicon
using Weave
using AverageShiftedHistograms

save("doc/API.md", AverageShiftedHistograms)
weave(Pkg.dir("AverageShiftedHistograms", "doc", "examples", "ash1.mdw"), doctype="github")
weave(Pkg.dir("AverageShiftedHistograms", "doc", "examples", "ash2.mdw"), doctype="github")
