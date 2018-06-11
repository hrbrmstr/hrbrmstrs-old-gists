library(grid)
library(hrbrthemes)
library(tidyverse)

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "A Title", subtitle = "A Subtitle") +
  theme_ipsum_rc(grid="XY") -> gg

gb <- ggplot_build(gg)
gt <- ggplot_gtable(gb)

gt$layout$l[gt$layout$name %in% c("title", "subtitle")] <- 2

grid.newpage()
grid.draw(gt)

