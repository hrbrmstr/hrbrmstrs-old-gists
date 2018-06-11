complexify <- function(x) {
  return(list(thing=rep(x, 10)))
}

v <- c(30, 40, 50)

lapply(v, complexify)
sapply(v, complexify)
