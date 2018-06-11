gg <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
ggsub <- ggplot(mtcars, aes(cyl)) + geom_bar()
ggsub_grob <- ggplotGrob(ggsub)
gg + annotation_custom(ggsub_grob, xmin=4, xmax=5.5, ymin=22.5, ymax=32.5)
