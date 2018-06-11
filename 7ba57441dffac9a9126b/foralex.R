library(rgdal)
library(rgeos)
library(maptools)
library(mapproj)

us <- readOGR("http://bl.ocks.org/mbostock/raw/4090846/us.json", "states")
proj4string(us) <- CRS("+proj=merc")

map <- fortify(us)

gg <- ggplot()
gg <- gg + geom_map(data=map, map=map,
                    aes(x=long, y=lat, map_id=id, group=group),
                    fill="#ffffff", color="#0e0e0e", size=0.15)
gg <- gg + xlim(-124.848974, -66.885444)
gg <- gg + ylim(24.396308, 49.384358)
gg <- gg + coord_map(projection="albers", lat=39, lat1=45)

gg <- gg + labs(x=NULL, y=NULL, title=NULL)
gg <- gg + theme(legend.position="bottom")
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(plot.title=element_text(size=16))
gg
