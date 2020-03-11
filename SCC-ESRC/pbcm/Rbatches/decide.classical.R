# get our own decisions using classical model for Ratabase
decide.classical <- function(method,
                             alpha,
                             cat,
                             datafolder = "../data/csv") {
  do_one_alpha <- function(X) {
    alp <- X
    out <- data.frame(ID=cat$ID, method=method, alpha=alp, decision=NA)
    for (id in cat$ID) {
      cat(paste0("Working on dataset ID ", id, "..."))

      # turn frequency data into response data using V
      data <- cre::prepare_data(read.csv(paste(datafolder, cat[cat$ID==id, ]$File, sep="/")), format="wide")
      responsedata <- freq2resp(data, V=round(cat[cat$ID==id, ]$V))

      # get decision
      dec <- cre::fit.cre.classical(data=responsedata, method=method, alpha=alp)
      out[out$ID==id, ]$decision <- as.character(dec$decision)
      cat(" done!\n")
    }
    out
  }

  do.call(rbind, lapply(X=alpha, FUN=do_one_alpha))
}

