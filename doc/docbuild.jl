# To build docs, run include("doc/docbuild.jl") from repository root folder

using Lexicon
using Weave
using AverageShiftedHistogram

save("doc/API.md", AverageShiftedHistogram)
# weave(Pkg.dir("AverageShiftedHistogram", "doc", "examples", "ash1.mdw"), doctype="github")
weave(Pkg.dir("AverageShiftedHistogram", "doc", "examples", "ash2.mdw"), doctype="github")
