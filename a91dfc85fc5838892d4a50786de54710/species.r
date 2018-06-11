library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)

trans <- c(A="Present Day", B="ICC RCP 2.6", C="Climate Action Tracker\n(2015 estimate (+2.7°C)\n", D="Climate Interactive\n(2015 estimate (+3.5°C)\n", E="IPCC RCP 8.5")

wrap_it <- wrap_format(16)

scenarios <- read.csv("scenarios.csv")
scenarios <- gather(scenarios, scenario, value, -Species)
scenarios <- mutate(scenarios, scenario=trans[scenario])
scenarios <- mutate(scenarios, Species=wrap_it(Species))
scenarios <- mutate(scenarios, Species=factor(Species, levels=unique(Species)))
scenarios <- bind_rows(scenarios, filter(scenarios, Species=="Finfish"))

coord_radar <- function (theta = "x", start = 0, direction = 1) {
 theta <- match.arg(theta, c("x", "y"))
 r <- if (theta == "x") "y" else "x"
 ggproto("CoordRadar", CoordPolar, theta = theta, r = r, start = start, 
      direction = sign(direction),
      is_linear = function(coord) TRUE)
}

gg <- ggplot()
gg <- gg + geom_path(data=scenarios,
                     aes(Species, y=value, linetype=scenario, group=scenario))
gg <- gg + scale_y_continuous(limits=c(0, 13), breaks=0:10)
gg <- gg + scale_linetype(name="Emission scenarios\n")
gg <- gg + coord_radar(start=-2*(pi / 13))
gg <- gg + labs(x=NULL, y=NULL)
gg <- gg + theme_bw()
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(axis.text.y=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg
