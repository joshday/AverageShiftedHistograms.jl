var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "AverageShiftedHistograms.jl",
    "title": "AverageShiftedHistograms.jl",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#AverageShiftedHistograms.jl-1",
    "page": "AverageShiftedHistograms.jl",
    "title": "AverageShiftedHistograms.jl",
    "category": "section",
    "text": "An Average Shifted Histogram (ASH) estimator is essentially a kernel density calculated with a fine-partition histogram."
},

{
    "location": "index.html#AverageShiftedHistograms.ash",
    "page": "AverageShiftedHistograms.jl",
    "title": "AverageShiftedHistograms.ash",
    "category": "Function",
    "text": "ash(y, x::Range = extendrange(y); m = 5, kernel = Kernels.biweight)\n\nFit an average shifted histogram where:     - y is the data     - x is a range of values where the density should be estimated     - m is a smoothing parameter.  It is the number of adjacent histogram bins on either side used to estimate the density.     - kernel is the kernel used to smooth the estimate\n\nMake changes to the estimate (add more data, change kernel, or change smoothing parameter):\n\nash!(o::Ash; kernel = newkernel, m = newm)\nash!(o::Ash, y; kernel = newkernel, m = newm)\n\n\n\n"
},

{
    "location": "index.html#Univariate-Usage-1",
    "page": "AverageShiftedHistograms.jl",
    "title": "Univariate Usage",
    "category": "section",
    "text": "The main function exported by AverageShiftedHistograms is ash.ash"
},

{
    "location": "index.html#Univariate-Toy-Example-1",
    "page": "AverageShiftedHistograms.jl",
    "title": "Univariate Toy Example",
    "category": "section",
    "text": "using AverageShiftedHistograms\nusing Plots; gr()\n\ny = randn(100_000)\n\no = ash(y, -5:.1:5)\n\nplot(o)(Image: )# BEWARE OVERSMOOTHING!\no = ash(y, -5:.1:5, m = 20)\nplot(o)(Image: )"
},

{
    "location": "index.html#Bivariate-Usage-1",
    "page": "AverageShiftedHistograms.jl",
    "title": "Bivariate Usage",
    "category": "section",
    "text": "ash(x, y; kw...)\nash(x, y, rngx, rngy; kw...)x, y\nThe bivariate data series (each is an AbstractVector)\nrngx, rngy\nThe histogram partition for x and y, respectively\nkw... Keyword arguments are\nmx = 5, my = 5\nSmoothing parameters for x and y\nkernelx = Kernels.biweight, kernely = Kernels.biweight\nSmoothing kernels for x and y\nwarnout = true\nPrint warning if density is nonzero on the edge of rngx or rngy"
},

{
    "location": "index.html#Bivariate-Toy-Example-1",
    "page": "AverageShiftedHistograms.jl",
    "title": "Bivariate Toy Example",
    "category": "section",
    "text": "using AverageShiftedHistograms\nusing Plots; pyplot()\n\nx = randn(10_000)\ny = x + randn(10_000)\n\no = ash(x, y)\n\nplot(o)(Image: )"
},

{
    "location": "index.html#Methods-1",
    "page": "AverageShiftedHistograms.jl",
    "title": "Methods",
    "category": "section",
    "text": "Suppose o = ash(x), o2 = ash(x, y)Get range/density values as a Tuplexy(o)  # Vector range x, Vector density y\n\nxyz(o2) # Vector ranges x,y, Matrix density zChange smoothing parameter(s) and/or kernel(s)ash!(o; m = 2, kernel = Kernels.epanechnikov)\n\nash!(o2; mx = 3, my = 1, kernely = Kernels.epanechnikov)Update the estimate by adding more datafit!(o, x)\n\nfit!(o2, x, y)Calculate approximate mean/variance/quantilesmean(o)\nvar(o)\nstd(o)\nquantile(o, .5)\nquantile(o. [.25, .5, .75])\nDistributions.pdf(o, .4)\nDistributions.cdf(o, .4)\n\nmean(o2)\nvar(o2)\nstd(o2)Diagnosticsnout(o)  # number of observations that fell outside the provided range\nnobs(o)  # number of observations passed to the Ash object"
},

]}
