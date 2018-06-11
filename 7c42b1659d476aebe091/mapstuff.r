library(sp)
library(maptools)
library(rgeos)
library(rgdal)
library(ggplot2)
library(tigris)
library(ggthemes)

us <- congressional_districts(TRUE)
nh <- subset(us, STATEFP=="33")
nh_map <- fortify(nh, region="GEOID")

str(nh_map)

losers <- data.frame(id=c("3301", "3302"),
                     votes=c(0.3, 0.7))

gg <- ggplot()
gg <- gg + geom_map(data=nh_map, map=nh_map,
                    aes(x=long, y=lat, map_id=id),
                    fill="white", color="black")
gg <- gg+ geom_map(data=losers, map=nh_map,
                   aes(fill=votes, map_id=id))
gg <- gg + coord_map()
gg <- gg + theme_map()
gg <- gg + theme(legend.position="right")
gg
