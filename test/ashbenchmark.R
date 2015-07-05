rm(list=ls())

setwd(".julia/v0.3/AverageShiftedHistograms/test/")
library(ash)
library(lineprof)
sessionInfo()

# Here we benchmark the ash estimate of 100,000,000 normal observations
x <- rnorm(10000000)
f <- function() {
  b = bin1(x, c(-6, 6), 1000)
  a = ash1(b, 5)
}
  
lineprof(f())
