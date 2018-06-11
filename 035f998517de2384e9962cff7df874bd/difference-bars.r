library(ggplot2)
library(dplyr)
library(scales)

df <- data_frame(bucket=sprintf("Bucket %s", LETTERS[1:5]),
                 budgeted=c(140, 125, 125, 100, 100),
                 actual=c(150, 140, 115, 90, 115))
df <- mutate(df, bucket=factor(bucket, levels=rev(bucket)))

diff_df <- mutate(df, difference=actual-budgeted, col=factor(sign(difference)))
diff_df <- mutate(diff_df, bucket=factor(bucket, levels=rev(levels(bucket))))

gg <- ggplot(diff_df)
gg <- gg + geom_segment(aes(x=bucket, xend=bucket,
                            y=0, yend=difference, color=col), size=7)
gg <- gg + geom_hline(yintercept=0, color="#b2b2b2")
gg <- gg + scale_y_continuous(expand=c(0,0), limits=c(-15, 15), label=dollar)
gg <- gg + scale_color_manual(name=NULL, values=c("#b2182b", "#2166ac"), labels=c("Shortfall", "Surplus"))
gg <- gg + labs(x=NULL, y=NULL,
                title="The budget surplus from Buckets A, B, & E\ncompensates for the shortfall in Buckets C & D",
                caption="Source: http://stephanieevergreen.com/overlapping-bars/")
gg <- gg + theme_minimal(base_family="Arial Narrow")
gg <- gg + theme(axis.text.y=element_text(margin=margin(r=-8)))
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(panel.grid.major.x=element_blank())
gg <- gg + theme(plot.title=element_text(face="bold", margin=margin(b=20)))
gg <- gg + theme(plot.caption=element_text(size=8, margin=margin(t=10, r=0)))
gg <- gg + theme(legend.position=c(0.875, 0.05))
gg <- gg + theme(legend.direction="horizontal")
gg <- gg + theme(legend.background=element_rect(fill="white", color="white"))
gg

