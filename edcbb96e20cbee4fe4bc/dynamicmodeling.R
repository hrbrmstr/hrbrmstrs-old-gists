a <- -.6 #slope
j <- 0
for (a in seq(-3, 3, by=0.1)) {
  b <- .3  #intercept
  timeserieslength <- 10 #Number of iterations
  y1 <- .3 #initial Value
  y2 <- 0
  t <- 0
  for (i in 1:timeserieslength) {
    y2[i] <- (a*y1[i])+b
    t[i] <- i
    if (i < timeserieslength){y1[i+1]=y2[i]
    }
  }
  print(j)
  png(sprintf("/Users/bob/aa/aa-%03d.png", j))
  j <- j + 1
  plot(t, y2, type="o", ylab="Y", xlab="time", pch=20, lwd=2)
  title(main = list(sprintf("Figure 1: Y over time (a=%2.1f)", a), cex=1.5, col="black", font=1))
  dev.off()

}

setwd("/Users/bob/aa/")
system("convert -delay 45 -loop 0 aa*g thing.gif")
