library(ggplot2)
library(readr)
library(dplyr)
library(tidyr)
library(scales)

senate <- read_csv("senate.csv")

sen_avg <- summarise(group_by(senate, congress),
                     avg=mean(Score))

gg <- ggplot(sen_avg, aes(x=factor(congress), y=avg))
gg <- gg + geom_bar(stat="identity", fill="#802b7c")
gg <- gg + annotate("text", x="103", y=0.5, label="More Partisan")
gg <- gg + annotate("text", x="103", y=-0.5, label="Less Partisan")
gg <- gg + scale_y_continuous(limits=c(-0.5, 0.5))
gg <- gg + labs(x="Session", y=NULL,
                title="Bipartisanship in the Senate has declined sharply since 1999")
gg <- gg + theme_bw()
gg <- gg + theme(panel.background=element_blank())
gg <- gg + theme(panel.grid.major.x=element_blank())
gg <- gg + theme(panel.grid.minor.x=element_blank())
gg <- gg + theme(panel.grid.minor.y=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.position="none")
gg
