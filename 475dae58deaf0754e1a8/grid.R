library(ggplot2)
library(tidyr)

dat <- as.data.frame(matrix(rep(c(rep("A", 24), rep("B", 8)), 10), nrow=10, byrow=TRUE))
dat$y <- rownames(dat)

dat %>%
  gather(x, value, -y) %>%
  mutate(x=as.numeric(gsub("V", "", x))) -> dat

gg <- ggplot(dat, aes(x=x, y=y, fill=value))
gg <- gg + geom_tile(color="white", size=1)
gg <- gg + coord_equal()
gg <- gg + labs(x="One square == 1m people", y=NULL, title="Anthem record loss as a visual fraction of US Population")
gg <- gg + scale_fill_manual(values=c("#969696", "#cb181d"))
gg <- gg + theme_bw()
gg <- gg + theme(text=element_text(family="Open Sans"))
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(legend.position="none")
gg <- gg + theme(axis.text=element_blank())
gg <- gg + theme(axis.title.x=element_text(size=8))
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(plot.title=element_text(size=12))
gg

ggsave("grid.svg", gg, width=7, height=3)