# Run this file to build docs

using Lexicon
using Weave
using AverageShiftedHistograms

save("doc/API.md", AverageShiftedHistograms)

weave(Pkg.dir("AverageShiftedHistograms", "doc", "examples", "ash1.jmd"),
      doctype = "github", informat = "markdown")

weave(Pkg.dir("AverageShiftedHistograms", "doc", "examples", "ash2.jmd"),
      doctype = "github", informat = "markdown")

weave(Pkg.dir("AverageShiftedHistograms", "doc", "examples", "update.jmd"),
      doctype = "github", informat = "markdown")

weave(Pkg.dir("AverageShiftedHistograms", "doc", "examples", "update2.jmd"),
      doctype = "github", informat = "markdown")
