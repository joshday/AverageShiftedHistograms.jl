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
    "text": "ash(y, x::Range = extendrange(y); m = 5, kernel = Kernels.biweight)\n\nFit an average shifted histogram where:\n\ny is the data\nx is a range of values where the density should be estimated\nm is a smoothing parameter.  It is the number of adjacent histogram bins on either side used to estimate the density.\nkernel is the kernel used to smooth the estimate\n\nMake changes to the estimate (add more data, change kernel, or change smoothing parameter):\n\nash!(o::Ash; kernel = newkernel, m = newm)\nash!(o::Ash, y; kernel = newkernel, m = newm)\n\n\n\n"
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
    "location": "index.html#AverageShiftedHistograms.Kernels",
    "page": "AverageShiftedHistograms.jl",
    "title": "AverageShiftedHistograms.Kernels",
    "category": "Module",
    "text": "The Kernels module defines a collection of (unnormalized) kernels.  Available kernels are\n\nbiweight\ncosine\nepanechnikov\ntriangular\ntricube\ntriweight\nuniform\ngaussian\nlogistic\n\n\n\n"
},

{
    "location": "index.html#Kernel-Functions-1",
    "page": "AverageShiftedHistograms.jl",
    "title": "Kernel Functions",
    "category": "section",
    "text": "Any nonnegative symmetric function can be provided to ash to be used as a kernel.  The function does not need to be normalized (integrate to 1) as the fitting procedure takes care of this.Kernels<img width = 700 src = \"https://user-images.githubusercontent.com/8075494/30523575-acd48de2-9bb1-11e7-8f0f-3ce2ab09c713.png\">"
},

]}
