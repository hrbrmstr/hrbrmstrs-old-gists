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

gg <- ggplot(data.frame(m), aes(x=X1, y=X2))
gg <- gg + geom_path() 
gg <- gg + coord_equal()
gg <- gg + labs(x="", y="", title="Random Walk The Plancks Constant")
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid=element_blank())
gg
