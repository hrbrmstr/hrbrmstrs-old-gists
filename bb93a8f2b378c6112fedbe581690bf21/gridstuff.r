library(grid)
library(gridExtra)

mydf <- data.frame(id = c(1:5), value = c("A","B","C","D","E"))

mytheme <- ttheme_default(base_size = 10, 
                          core = list(fg_params=list(hjust=0, x=0.01),
                                      bg_params=list(fill=c("white", "lightgrey"))))

tg <- tableGrob(mydf, cols = NULL, theme = mytheme, rows = NULL)

for (i in 1:5) {
  tg$grobs[[i]] <- editGrob(tg$grobs[[i]], gp=gpar(fontface="bold"))
}

space <- 30 ; tg$widths[1] <- unit(max(unlist(lapply(tg$grobs[1:5], function(g) {convertWidth(grobWidth(g), "pt", TRUE)}))) + space, "pt")

grid.newpage()
grid.draw(tg)

