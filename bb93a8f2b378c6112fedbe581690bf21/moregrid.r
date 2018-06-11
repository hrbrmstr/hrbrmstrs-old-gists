library(grid)
library(gridExtra)

tg <- tableGrob(iris[1:5, 1:3])

for (i in c(19,24,29)) tg$grobs[[i]] <- editGrob(tg$grobs[[i]], gp=gpar(col="white"))
for (i in c(34,39,44)) tg$grobs[[i]] <- editGrob(tg$grobs[[i]], gp=gpar(fill="blue"))

grid.newpage()
grid.draw(tg)



