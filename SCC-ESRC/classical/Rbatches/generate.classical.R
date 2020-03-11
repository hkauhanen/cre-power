# generate synthetic data from classical CRE/VRE model (2 contexts)
generate.classical <- function(H,
                               V,
                               E, # CRE when = 0
                               empslopes,
                               low_bound_range,
                               high_bound_range,
                               what) {
  # sample lower and higher boundaries
  lowbound <- runif(n=1, 
                    min=low_bound_range[1], 
                    max=low_bound_range[2])
  highbound <- runif(n=1, 
                     min=high_bound_range[1], 
                     max=high_bound_range[2])

  # sample maximum slope
  mean_ms <- mean(log(empslopes$max))
  sd_ms <- sd(log(empslopes$max))
  max_slope <- exp(rnorm(n=1, mean=mean_ms, sd=sd_ms))

  # sample E2
  mean_E2 <- mean(log(empslopes$E2))
  sd_E2 <- sd(log(empslopes$E2))
  E2 <- exp(rnorm(n=1, mean=mean_E2, sd=sd_E2))

  # determine minimum slope
  min_slope <- (1-E)*max_slope
  s <- c(min_slope, max_slope)

  # determine intercepts
  min_k <- 0
  max_k <- E2*2*(1/mean(s))*log(1/(sqrt(2) - 1))
  k <- c(min_k, max_k)
  if (runif(1) < 0.5) {
    k <- rev(k)
  }

  # construct dates
  low1 <- k[1] + (1/s[1])*log(lowbound/(1 - lowbound))
  high1 <- k[1] + (1/s[1])*log(highbound/(1 - highbound))
  low2 <- k[2] + (1/s[2])*log(lowbound/(1 - lowbound))
  high2 <- k[2] + (1/s[2])*log(highbound/(1 - highbound))
  lows <- c(low1, low2)
  highs <- c(high1, high2)
  #dates <- seq(from=min(lows), to=max(highs), length.out=H)
  dates <- seq(from=max(lows), to=min(highs), length.out=H)

  # generate synthetic data
  datesrepped <- unlist(lapply(dates, function(x) { rep(x=x, times=V) }))
  responder <- function(p) { rbinom(n=V, size=1, prob=p) }
  frequentizer <- function(x) { sum(x)/V }
  if (what == "responses") {
    out <- NULL
    for (context in 1:2) {
      responses <- unlist(lapply(hipster::logistic(t=dates, s=s[context], k=k[context]), responder))
      hereout <- data.frame(date=datesrepped, context=context, response=responses)
      out <- rbind(out, hereout)
    }
  } else if (what == "frequencies") {
    out <- NULL
    for (context in 1:2) {
      frequencies <- unlist(lapply(lapply(hipster::logistic(t=dates, s=s[context], k=k[context]), responder), frequentizer))
      hereout <- data.frame(date=dates, context=context, frequency=frequencies)
      out <- rbind(out, hereout)
    }
  } else {
    stop("invalid what")
  }

  # our curve-fitting algorithms assume context is a factor, so make sure it is
  out$context <- factor(out$context)

  # return
  out
}

