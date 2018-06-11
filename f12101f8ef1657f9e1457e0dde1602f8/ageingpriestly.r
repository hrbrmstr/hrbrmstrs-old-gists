library(ggplot2)
library(dplyr)

ft <- read.csv("ftpop.csv", stringsAsFactors=FALSE)

arrange(ft, start_year) %>%
  mutate(country=factor(country, levels=c(" ", rev(country), "  "))) -> ft

ft_labs <- data_frame(
  x=c(1900, 1950, 2000, 2050, 1900, 1950, 2000, 2050),
  y=c(rep(" ", 4), rep("  ", 4)),
  hj=c(0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5),
  vj=c(1, 1, 1, 1, 0, 0, 0, 0)
)

ft_lines <- data_frame(x=c(1900, 1950, 2000, 2050))

ft_ticks <- data_frame(x=seq(1860, 2050, 10))

gg <- ggplot()

# tick marks & gridlines
gg <- gg + geom_segment(data=ft_lines, aes(x=x, xend=x, y=2, yend=16),
                        linetype="dotted", size=0.15)
gg <- gg + geom_segment(data=ft_ticks, aes(x=x, xend=x, y=16.9, yend=16.6),
                        linetype="dotted", size=0.15)
gg <- gg + geom_segment(data=ft_ticks, aes(x=x, xend=x, y=1.1, yend=1.4),
                        linetype="dotted", size=0.15)

# double & triple bars
gg <- gg + geom_segment(data=ft, size=5, color="#b0657b",
                        aes(x=start_year, xend=start_year+double, y=country, yend=country))
gg <- gg + geom_segment(data=ft, size=5, color="#eb9c9d",
                        aes(x=start_year+double, xend=start_year+double+triple, y=country, yend=country))

# tick labels
gg <- gg + geom_text(data=ft_labs, aes(x, y, label=x, hjust=hj, vjust=vj), size=3)

# annotations
gg <- gg + geom_label(data=data.frame(), hjust=0, label.size=0, size=3,
                      aes(x=1911, y=7.5, label="France is set to take\n157 years to triple the\nproportion ot its\npopulation aged 65+,\nChina only 34 years"))
gg <- gg + geom_curve(data=data.frame(), aes(x=1911, xend=1865, y=9, yend=15.5),
                      curvature=-0.5, arrow=arrow(length=unit(0.03, "npc")))
gg <- gg + geom_curve(data=data.frame(), aes(x=1915, xend=2000, y=5.65, yend=5),
                      curvature=0.25, arrow=arrow(length=unit(0.03, "npc")))

# pretty standard stuff here
gg <- gg + scale_x_continuous(expand=c(0,0), limits=c(1860, 2060))
gg <- gg + scale_y_discrete(drop=FALSE)
gg <- gg + labs(x=NULL, y=NULL, title="Emerging markets are ageing at a rapid rate",
                subtitle="Time taken for population aged 65 and over to double and triple in proportion (from 7% of total population)",
                caption="Source: http://on.ft.com/1Ys1W2H")
gg <- gg + theme_minimal()
gg <- gg + theme(axis.text.x=element_blank())
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(plot.margin=margin(10,10,10,10))
gg <- gg + theme(plot.title=element_text(face="bold"))
gg <- gg + theme(plot.subtitle=element_text(size=9.5, margin=margin(b=10)))
gg <- gg + theme(plot.caption=element_text(size=7, margin=margin(t=-10)))
gg
