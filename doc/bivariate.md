# `BivariateASH`


## Construction
There are two methods for creating a `BivariateASH` object.

### `ash(x::VecF, y::VecF, rngx::Range, rngy::Range;
         mx::Int = 5, my::Int = 5, kernelx::Symbol = :biweight, kernely::Symbol = :biweight)`

### `ash(x::VecF, y::VecF;
         nbinx::Int = 1000, nbiny::Int = 1000, r::Real = 0.2, mx = 5, my = 5, kernelx = :biweight, kernely = :biweight)`
