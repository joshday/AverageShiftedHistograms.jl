using Documenter, AverageShiftedHistograms

makedocs(
    format = Documenter.HTML(),
    sitename = "AverageShiftedHistograms.jl",
    authors = "Josh Day",
    clean = true,
    pages = [
        "index.md",
        "kernels.md"
        "api.md"
    ]
)

deploydocs(
    repo   = "github.com/joshday/AverageShiftedHistograms.jl.git",
)
