# Cross-fit. To be run on Konstanz SCC (GridEngine).

# required stuff
source("Rbatches/generate.classical.R")
source("Rbatches/power.classical.R")
source("Rbatches/posthoc.classical.R")
library(pbcm, lib.loc="./lib")
library(cre, lib.loc="./lib")
library(hipster, lib.loc="./lib")

# command-line arguments from Condor submit script
args <- commandArgs(trailingOnly=TRUE)
job <- as.numeric(args[2])

# seed RNG
seed <- hipster::seed_seed(seed=20191210, n=job)

# empirical stuff
catalogue <- read.csv("database/constant-ratabase.csv")
empslopes <- read.csv("database/slopes.csv")
boundaries <- read.csv("database/boundaries.csv")

# parameter grid
pargrid <- expand.grid(alpha=c(0.001, 0.01, 0.05), ID=1:46)

# parameters
alpha <- pargrid[job, ]$alpha
id <- pargrid[job, ]$ID
reps <- 1000

# run
runt <- system.time(res <- posthoc.classical(reps=reps, ID=id, method="M6", alpha=alpha, cat=catalogue, empslopes=empslopes, boundaries=boundaries))[1]

# meta
res$own_boundaries <- TRUE
runtimes <- data.frame(ID=id, reps=reps, alpha=alpha, runtime=runt)

# writeout
write.csv(res, file=paste("results/confusion", args[2], "csv", sep="."), row.names=FALSE)
write.csv(runtimes, file=paste("results/runtime", args[2], "csv", sep="."), row.names=FALSE)
