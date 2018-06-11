library(ggplot2)
library(readr)
library(ggthemes)

dat <- read_csv("senate_bipartisan_index.csv")
dat <- mutate(dat, party=c(D="Democrat", R="Republican")[party])

gg <- ggplot(dat)
gg <- gg + geom_hline(yintercept=0, color="black", size=0.33)
gg <- gg + geom_violin(aes(x=congress, y=score, group=congress, fill=party),
                       width=1, size=0.25, alpha=0.85)
gg <- gg + geom_boxplot(aes(x=congress, y=score, group=congress),
                        width=0.5, fill=NA, size=0.25, alpha=0.9)
gg <- gg + scale_fill_manual(values=c("#3288bd", "#d53e4f"))
gg <- gg + coord_flip()
gg <- gg + facet_wrap(~party)
gg <- gg + theme_tufte(base_family="APHont")
gg <- gg + labs(x=NULL, y=NULL, title="Luger Bipartisan Index Score")
gg <- gg + theme(strip.text=element_text(hjust=0, face="bold"))
gg <- gg + theme(panel.grid=element_line(color="#2b2b2b", size=0.15))
gg <- gg + theme(panel.grid.major.y=element_blank())
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.position="none")
gg <- gg + theme(plot.title=element_text(hjust=0, face="bold"))
gg
