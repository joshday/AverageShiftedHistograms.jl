using Weave

dir = Pkg.dir("AverageShiftedHistograms", "doc", "examples")

examples = (
    "/ash1.jmd",
    "/ash2.jmd",
    "/update.jmd",
    "/update2.jmd"
    )



for i in examples
    weave(dir * i, doctype="github", informat="markdown")
end
