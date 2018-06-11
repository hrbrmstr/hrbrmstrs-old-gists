library(ggplot2) # devtools::install_github("hadley/ggplot2") or subtitles won't work
library(tidyr)
library(dplyr)
library(readr)
library(scales)

URL <- "https://static01.nyt.com/newsgraphics/2016/04/21/undervote/ad8bd3e44231c1091e75621b9f27fe31d116999f/data.tsv"
fil <- "nytimes_vote.tsv"
if (!file.exists(fil)) download.file(URL, fil)

df <- read_tsv(fil)
df <- rename(df, `Someone else`=undervt, `Hilary Clinton`=clintonpct, `Bernie Sanders`=sanderspct)
df <- gather(select(df, -tvotes), party, pct, -ratio, -fips)
df <- arrange(df, fips, ratio)
df <- mutate(df, party=factor(party, levels=c("Hilary Clinton", "Bernie Sanders", "Someone else")))
df

gg <- ggplot(df)
gg <- gg + geom_point(aes(x=ratio, y=pct, fill=party), 
                      color="white", shape=21, size=3, alpha=0.8)
gg <- gg + geom_text(data=data.frame(label="↑ Share of 2016 primary vote"),
                     aes(x=0, y=0.95, label=label), vjust=1, hjust=0, size=3,
                     fontface="bold", family="Arial Narrow")
gg <- gg + scale_y_continuous(expand=c(0,0.01), label=percent, limits=c(0, 0.95))
gg <- gg + scale_x_continuous(expand=c(0,0), 
                              limits=c(0, 4.5),
                              breaks=seq(0, 5.0, 0.5),
                              labels=gsub("5.0", "", sprintf("%1.1f", seq(0, 5.0, 0.5))))
gg <- gg + scale_fill_manual(name="", values=c(`Hilary Clinton`="#5fa0d6",
                                               `Bernie Sanders`="#83BC57",
                                               `Someone else`="#d65454"))
gg <- gg + labs(x="Ratio of registered Democrats to Obama voters →", y=NULL,
                title="The Kinds of Places Sanders Beats Clinton",
                subtitle="Each dot on this chart represents the share of a county's vote for a candidate in the 2016 Democratic primary")
gg <- gg + theme_bw(base_family="Arial Narrow")
gg <- gg + theme(plot.margin=margin(10, 10, 10, 10))
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(panel.grid.major=element_line(linetype="dotted", size=0.5))
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(axis.text=element_text(size=8))
gg <- gg + theme(axis.text.x=element_text(hjust=c(0, rep(0.5, 8), 1)))
gg <- gg + theme(axis.text.y=element_text(vjust=c(0, 0.5, 0.5, 0.5)))
gg <- gg + theme(axis.title.x=element_text(hjust=1, face="bold", size=9))
gg <- gg + theme(plot.title=element_text(face="bold"))
gg <- gg + theme(legend.position="top")
gg <- gg + theme(legend.key=element_blank())
gg
