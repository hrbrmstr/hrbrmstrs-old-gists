library(viridis)

x <- y <- seq(-8*pi, 8*pi, len = 40)
r <- sqrt(outer(x^2, y^2, "+"))

viridis_b <- function(n) { viridis(n, option="B") }

filled.contour(cos(r^2)*exp(-r/(2*pi)), 
               axes=FALSE,
               color.palette=viridis_b,
               asp=1)