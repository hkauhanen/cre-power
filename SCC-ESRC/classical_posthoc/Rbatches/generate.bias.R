# generate synthetic data from KW bias model (2 contexts)
generate.bias <- function(H,
                          V,
                          bias1,
                          bias2,
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

  # sample median slope
  mean_ms <- mean(log(empslopes$median))
  sd_ms <- sd(log(empslopes$median))
  s <- exp(rnorm(n=1, mean=mean_ms, sd=sd_ms))

  # set intercept at 0
  k <- 0

  # set biases
  b <- c(bias1, bias2)

  # construct dates
  dates <- seq(from=k + (1/s)*log(lowbound/(1 - lowbound)),
               to=k + (1/s)*log(highbound/(1 - highbound)),
               length.out=H)

  # generate synthetic data
  datesrepped <- unlist(lapply(dates, function(x) { rep(x=x, times=V) }))
  responder <- function(p) { rbinom(n=V, size=1, prob=p) }
  frequentizer <- function(x) { sum(x)/V }
  KW <- function(t, s, k, b) { 
    underlying <- hipster::logistic(t=t, s=s, k=k)
    underlying + b*underlying*(1 - underlying)
  }
  if (what == "responses") {
    out <- NULL
    for (context in 1:2) {
      responses <- unlist(lapply(KW(t=dates, s=s, k=k, b=b[context]), responder))
      hereout <- data.frame(date=datesrepped, context=context, response=responses)
      out <- rbind(out, hereout)
    }
  } else if (what == "frequencies") {
    out <- NULL
    for (context in 1:2) {
      frequencies <- unlist(lapply(lapply(KW(t=dates, s=s, k=k, b=b[context]), responder), frequentizer))
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

