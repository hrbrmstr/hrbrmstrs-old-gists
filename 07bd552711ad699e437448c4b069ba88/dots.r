library(ggplot2)
library(scales)

# simulate some data

df1 <- data.frame(grp="8.2", seg=1:13,
                  range_limit=c(33,260,170,390,400,850,900,860,870,1000,880,830,770))
df1.1 <- data.frame(grp="8.2", seg=14:37, range_limit=1000)
df2 <- data.frame(grp="8.1", seg=1:10,
                  range_limit=c(260,400,420,250,410,500,600,550,700,650))
df2.1 <- data.frame(grp="8.1", seg=11:19, range_limit=1000)

df <- do.call(rbind, list(df1, df1.1, df2, df2.1))
df$grp <- factor(df$grp, levels=c("8.1", "8.2"))

pts.1 <- data.frame(grp="8.2",
                    seg=c(10,13,15,15),
                    rdng=c(320,160,800,780))
pts.2 <- data.frame(grp="8.1",
                    seg=c(3,13,13,13),
                    rdng=c(190,100,200,300))

pt <- rbind.data.frame(pts.1, pts.2)

gg <- ggplot()
gg <- gg + geom_rect(data=data.frame(grp=c("8.1", "8.2")),
                     aes(xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf, fill=grp), 
                     alpha=0.15)
gg <- gg + geom_segment(data=df, 
                        aes(x=0, xend=range_limit, y=seg, yend=seg),
                        linetype="dotted")
gg <- gg + geom_point(data=df, aes(x=0, y=seg, color="orange"))
gg <- gg + geom_point(data=df, aes(x=range_limit, y=seg, color="black"))
gg <- gg + geom_point(data=pt, aes(x=rdng, y=seg, color="orange"))
gg <- gg + scale_x_continuous(label=comma)
gg <- gg + scale_color_identity()
gg <- gg + facet_wrap(~grp, ncol=1, switch="y", scales="free_y")
gg <- gg + labs(x=NULL, y=NULL)
gg <- gg + theme_minimal()
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(axis.text.y=element_blank())
gg <- gg + theme(legend.position="none")
gg 