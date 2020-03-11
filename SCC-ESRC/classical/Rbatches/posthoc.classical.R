# post hoc power analysis over Ratabase using classical models
posthoc.classical <- function(reps,
                              ID,
                              method,
                              alpha,
                              cat,
                              empslopes,
                              boundaries = NA) {
  id <- ID
  if (is.na(boundaries)) {
    low_bound <- 0.05
    high_bound <- 0.95
  } else {
    # boundaries of 0 and 1 are inadmissible as the logistic tends to -Inf
    # and Inf. Replace these with 0.01 and 0.99.
    low_bound <- boundaries[boundaries$ID==id, ]$low_bound
    high_bound <- boundaries[boundaries$ID==id, ]$high_bound
    if (low_bound == 0) low_bound <- 0.01
    if (high_bound == 1) high_bound <- 0.99
  }

  # Monte Carlo analysis
  res <- power.classical(reps=reps, method=method, alpha=alpha, H=cat[cat$ID==id, ]$H, V=round(cat[cat$ID==id, ]$V), E=empslopes[empslopes$ID==id, ]$E, low_bound=low_bound, high_bound=high_bound, empslopes=empslopes)
  res <- cbind(ID=id, res)

  # Youden's J
  res$J <- res$TP/res$P + res$TN/res$N - 1

  res
}
