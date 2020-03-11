# Cross-fit. To be run on Konstanz SCC (GridEngine).

# required stuff
source("Rbatches/freq2resp.R")
source("Rbatches/generate.pbcm.responses.R")
source("Rbatches/posthoc.pbcm.responses.R")
library(pbcm, lib.loc="./lib")
library(cre, lib.loc="./lib")
library(hipster, lib.loc="./lib")

# command-line arguments from Condor submit script
args <- commandArgs(trailingOnly=TRUE)
job <- as.numeric(args[2])

# seed RNG
seed <- hipster::seed_seed(seed=20191210, n=job)

# parameter grid
pargrid <- data.frame(ID=rep(1:46, 3), model2=c(rep("bias", 2*46), rep("logistic", 46)), model1=c(rep("VRE", 46), rep("logistic", 46), rep("VRE", 46)))

# parameters
id <- pargrid[job, ]$ID
model1 <- as.character(pargrid[job, ]$model1)
model2 <- as.character(pargrid[job, ]$model2)
cat <- read.csv("database/constant-ratabase.csv")
datahere <- cre::prepare_data(read.csv(paste0("data/csv/", cat[cat$ID==id, ]$File)), format="wide")
V <- round(cat[cat$ID==id, ]$V)
H <- cat[cat$ID==id, ]$H
L <- cat[cat$ID==id, ]$L
budget <- 100
reps <- 1000
k <- seq(from=1, to=100, by=1)
boundaries <- read.csv("database/boundaries.csv")
low_bound <- boundaries[boundaries$ID==id, ]$low_bound
high_bound <- boundaries[boundaries$ID==id, ]$high_bound
if (low_bound == 0) low_bound <- 0.01
if (high_bound == 1) high_bound <- 0.99

# run
runtime <- system.time(res <- posthoc.pbcm(data=datahere,
					   genargs1=list(H=H, V=V, ID=id, low_bound=low_bound, high_bound=high_bound),
					   genargs2=list(H=H, V=V, ID=id, low_bound=low_bound, high_bound=high_bound),
					   model1=model1,
					   model2=model2,
					   budget=budget,
					   reps=reps,
					   k=k,
					   npb=TRUE,
					   V=V))[1]

# append metadata
res$raw$seed <- seed
res$raw$ID <- id
res$alphabeta$ID <- id
res$empirical$ID <- id
runt <- data.frame(ID=id, V=V, H=H, L=L, case=paste0(model1, "_v_", model2), budget=budget, reps=reps, no_of_ks=length(k), runtime=runtime)

# writeout
#write.csv(res$raw, file=paste("results/raw", args[2], "csv", sep="."), row.names=FALSE)
write.csv(res$alphabeta, file=paste("results/confusion", args[2], "csv", sep="."), row.names=FALSE)
write.csv(res$empirical, file=paste("results/empirical", args[2], "csv", sep="."), row.names=FALSE)
write.csv(runt, file=paste("results/runtime", args[2], "csv", sep="."), row.names=FALSE)
