using Documenter, AverageShiftedHistograms

makedocs(
    format = :html,
    sitename = "AverageShiftedHistograms.jl",
    authors = "Josh Day",
    clean = true,
    pages = [
        "index.md"
    ]
)

deploydocs(
    repo   = "github.com/joshday/AverageShiftedHistograms.jl.git",
    target = "build",
    osname = "linux",
    julia  = "0.6",
    deps   = nothing,
    make   = nothing
)
