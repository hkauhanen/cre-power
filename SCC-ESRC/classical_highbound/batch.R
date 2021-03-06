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

# empirical slopes
empslopes <- read.csv("database/slopes.csv")

# parameter grid
pargrid <- expand.grid(hb=seq(from=0.15, to=0.95, length.out=9), V=unique(round(exp(seq(from=log(50), to=log(500), length.out=10)))), H=unique(round(exp(seq(from=log(3), to=log(100), length.out=10)))))

# parameters
high_bound <- pargrid[job, ]$hb
E <- 0.255
V <- pargrid[job, ]$V
H <- pargrid[job, ]$H
methods <- c("M6")
reps <- 1000
alphas <- c(0.05)

# run
res <- NULL
for (method in methods) {
  for (alpha in alphas) {
    thisres <- power.classical(reps=reps, method=method, alpha=alpha, H=H, V=V, E=E, empslopes=empslopes, low_bound=0.05, high_bound=high_bound)
    res <- rbind(res, thisres)
  }
}

# writeout
write.csv(res, file=paste("results/confusion", args[2], "csv", sep="."), row.names=FALSE)
