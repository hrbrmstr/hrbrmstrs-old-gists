library(ggplot2)
library(dplyr)
library(scales)

df <- data_frame(bucket=sprintf("Bucket %s", LETTERS[1:5]),
                 budgeted=c(140, 125, 125, 100, 100),
                 actual=c(150, 140, 115, 90, 115))
df <- mutate(df, bucket=factor(bucket, levels=rev(bucket)))

gg <- ggplot(data=df, aes(y=bucket, yend=bucket))
gg <- gg + geom_segment(aes(x=budgeted, xend=0, color="Budgeted"), size=10)
gg <- gg + geom_segment(aes(x=actual, xend=0, color="Actual"), size=5)
gg <- gg + scale_x_continuous(expand=c(0,0), limits=c(0, 160),
                              breaks=seq(0, 160, 20), label=dollar)
gg <- gg + scale_color_manual(name=NULL, values=c(Budgeted="#bebebf", Actual="#1074bc"))
gg <- gg + guides(color=guide_legend(keywidth=0, override.aes=list(size=4)))
gg <- gg + labs(x=NULL, y=NULL,
                title="The budget surplus from Buckets A, B, & E\ncompensates for the shortfall in Buckets C & D",
                caption="Source: http://stephanieevergreen.com/overlapping-bars/")
gg <- gg + theme_minimal(base_family="Arial Narrow")
gg <- gg + theme(axis.text.x=element_text(margin=margin(t=-10)))
gg <- gg + theme(axis.text.y=element_text(margin=margin(r=-10)))
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(panel.grid.major.y=element_blank())
gg <- gg + theme(plot.title=element_text(face="bold"))
gg <- gg + theme(plot.margin=margin(20,20,20,20))
gg <- gg + theme(plot.caption=element_text(size=8, margin=margin(t=10, r=0)))
gg <- gg + theme(legend.position=c(0.875, 0.3))
gg <- gg + theme(legend.direction="horizontal")
gg <- gg + theme(legend.background=element_rect(fill="white", color="white"))
gg 
