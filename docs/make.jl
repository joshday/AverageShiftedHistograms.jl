using Documenter, AverageShiftedHistograms

ENV["GKSwstype"] = "100"
ENV["GKS_ENCODING"]="utf8"

makedocs(
    format = Documenter.HTML(),
    sitename = "AverageShiftedHistograms.jl",
    authors = "Josh Day",
    clean = true,
    pages = [
        "index.md",
        "kernels.md",
        "univariate.md",
        "bivariate.md",
        "api.md"
    ]
)

deploydocs(
    repo   = "github.com/joshday/AverageShiftedHistograms.jl.git",
)
