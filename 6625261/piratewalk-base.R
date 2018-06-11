set.seed(200109) # founding of The Pirate Bay

walk<-function(n) {
  m <- matrix(6.62606896e-34, ncol = 2, nrow = n) 
  i <- cbind(seq(n), sample(c(1, 2), n, TRUE)) 
  m[i] <- sample(c(-1, 1), n, TRUE) 
  m[,1] <- cumsum(m[, 1]) 
  m[,2] <- cumsum(m[, 2]) 
  m 
} 

m <- walk(1000) 

plot(0, type="n",xlab="x", ylab="y", main="Random Walk The Plancks Constant", xlim=range(m[,1]), ylim=range(m[,2])) 

segments(head(m[, 1], -1), head(m[, 2], -1), tail(m[, 1], -1), tail(m[,2], -1), col ="blue") 

# see plot here: http://flic.kr/p/fXMcrm