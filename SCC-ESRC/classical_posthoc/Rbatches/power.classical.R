# power analysis for classical methods
power.classical <- function(reps,
                            method,
                            alpha,
                            H,
                            V,
                            E,
                            empslopes,
                            low_bound = 0.05,
                            high_bound = 0.95) {
  # positives, negatives, true/false positives/negatives
  P <- NA
  N <- NA
  TP <- NA
  FP <- NA
  TN <- NA
  FN <- NA

  low_bound_range <- c(low_bound, low_bound)
  high_bound_range <- c(high_bound, high_bound)

  runtime <- system.time({
    resP <- replicate(reps, fitfun(method=method, alpha=alpha, H=H, V=V, E=E, empslopes=empslopes, low_bound_range=low_bound_range, high_bound_range=high_bound_range, what="responses"))
    resN <- replicate(reps, fitfun(method=method, alpha=alpha, H=H, V=V, E=0, empslopes=empslopes, low_bound_range=low_bound_range, high_bound_range=high_bound_range, what="responses"))
    resP <- resP[!is.na(resP)]
    if (length(resP) != 0) {
      TP <- sum(resP)
      P <- length(resP)
      FN <- P - TP
    }
    resN <- resN[!is.na(resN)]
    if (length(resN) != 0) {
      TN <- sum(!resN)
      N <- length(resN)
      FP <- N - TN
    }
  })[1]
  data.frame(H=H, V=V, E=E, low_bound=low_bound, high_bound=high_bound, method=method, reps=reps, alpha=alpha, runtime=runtime, runtime_scaled=runtime/(2*reps), P=P, TP=TP, FN=FN, N=N, TN=TN, FP=FP)
}


fitfun <- function(method,
                   alpha,
                   H,
                   V,
                   E,
                   empslopes,
                   low_bound_range,
                   high_bound_range,
                   what) {
  data <- generate.classical(H=H, V=V, E=E, empslopes=empslopes, low_bound_range=low_bound_range, high_bound_range=high_bound_range, what=what)
  cre::fit.cre.classical(data=data, method=method, alpha=alpha)$significant
}
