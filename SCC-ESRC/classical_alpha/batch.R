# Cross-fit. To be run on Konstanz SCC (GridEngine).

# required stuff
source("Rbatches/generate.classical.R")
source("Rbatches/power.classical.R")
library(pbcm, lib.loc="./lib")
library(cre, lib.loc="./lib")
library(hipster, lib.loc="./lib")

# command-line arguments from Condor submit script
args <- commandArgs(trailingOnly=TRUE)
job <- as.numeric(args[2])

# seed RNG
seed <- hipster::seed_seed(seed=20191210, n=job)

# empirical stuff
empslopes <- read.csv("database/slopes.csv")

# parameter grid
pargrid <- expand.grid(E=c(0.1325, 0.255, 0.3775), H=10, V=c(10, 100, 1000))

# parameters
alphas <- exp(seq(from=log(0.0001), to=log(1.0), length.out=20))
reps <- 1000
E <- pargrid[job, ]$E
H <- pargrid[job, ]$H
V <- pargrid[job, ]$V

# run
res <- do.call(rbind, lapply(X=alphas, FUN=function(X) { power.classical(reps=reps, method="M6", alpha=X, H=H, V=V, E=E, empslopes=empslopes, low_bound=0.05, high_bound=0.95) }))

# writeout
write.csv(res, file=paste("results/confusion", args[2], "csv", sep="."), row.names=FALSE)
