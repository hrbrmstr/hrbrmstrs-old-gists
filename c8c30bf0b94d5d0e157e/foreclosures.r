library(ggplot2)  # devtools::install_github("hrbrmstr/ggplot2")
library(hrbrmisc) # devtools::install_github("hrbrmstr/hrbrmisc")
library(readr)
library(dplyr)
library(ggmap)
library(grid)
library(scales)
library(ggalt)
library(gridExtra)

foreclosures <- read_csv("parcels_alldata2_sales_foreclosure.csv")
foreclosures$yr <- format(foreclosures$saledate, "%Y")
foreclosures <- filter(foreclosures, !is.na(yr))
foreclosures <- filter(foreclosures, as.numeric(yr) >= 2000)

ctr <- c(mean(range(foreclosures$coords_x1)), mean(range(foreclosures$coords_x2)))

gm <- get_googlemap(center=ctr, maptype="roadmap", color="bw", zoom=11)

gg <- ggmap(gm)
gg <- gg + geom_jitter(data=foreclosures, aes(x=coords_x1, y=coords_x2),
                       color="#a50f15", alpha=1/4)
gg <- gg + xlim(expand_range(range(foreclosures$coords_x1), mul=0.05))
gg <- gg + ylim(expand_range(range(foreclosures$coords_x2), mul=0.05))
gg <- gg + facet_wrap(~yr, ncol=4)
gg <- gg + labs(x=NULL, y=NULL, 
                title="Foreclosures in Athens, Georgia",
                subtitle="Data from 2000 to 2015",
                annotation="via: https://communitymapuga.cartodb.com/viz/61a821fe-ea22-11e5-bfd2-0ea31932ec1d/public_map")
gg <- gg + theme_hrbrmstr(grid=FALSE, axis=FALSE, ticks=FALSE)
gg <- gg + theme(axis.text=element_blank())
gg <- gg + theme(strip.text=element_text(family="OpenSans-CondensedBold", size=9))
gg <- gg + theme(plot.title=element_text(margin=margin(b=9)))
gg <- gg + theme(panel.border=element_rect(color="#2b2b2b", fill=NA, size=0.15))
gg <- gg + theme(panel.margin=unit(0.5, "cm"))
gg <- gg + theme(plot.annotation=element_text(size=6, hjust=1))
gg1 <- gg

gg <- ggplot()
gg <- gg + geom_bar(data=foreclosures, aes(x=yr), fill="#a50f15", width=0.5)
gg <- gg + scale_x_discrete(expand=c(0,0))
gg <- gg + scale_y_continuous(expand=c(0,0), limits=c(0, 600), breaks=c(0, 200, 400, 600))
gg <- gg + labs(x=NULL, y=NULL)
gg <- gg + theme_hrbrmstr(grid="Y")
gg <- gg + theme(axis.text.x=element_text(margin=margin(t=-4)))
gg <- gg + theme(axis.text.y=element_text(margin=margin(r=-4)))
gg <- gg + theme(panel.margin=margin(l=2.5, r=2.5, unit="cm"))
gg <- gg + theme(plot.margin=margin(l=2.5, r=2.5, unit="cm"))
gg2 <- gg

grid.arrange(gg1, gg2, ncol=1, heights=c(0.9, 0.1))

