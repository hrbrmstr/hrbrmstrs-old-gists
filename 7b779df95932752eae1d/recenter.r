library(rgeos)
library(maptools)
library(rgdal)
library(ggplot2)
library(ggthemes)
library(ggalt) # devtools::install_github("hrbrmstr/ggalt")

world <- readOGR("countries.geo.json", "OGRGeoJSON", stringsAsFactors=FALSE)
world <- gBuffer(world, byid=TRUE, width=0)
world <- nowrapRecenter(world)

plates <- readOGR("plates.json", "OGRGeoJSON", stringsAsFactors=FALSE)
plates <- nowrapRecenter(plates)

recenter_points <- function (obj) {
  crds <- coordinates(obj)
  inout <- (crds[, 1] < 0)
  if (all(inout)) { crds[, 1] <- crds[, 1] + 360 }
  else { if (any(inout)) { crds[, 1] <- ifelse(inout, crds[, 1] + 360, crds[, 1]) } }
  SpatialPointsDataFrame(crds, obj@data)
}

quakes <- readOGR("quakes.json", "OGRGeoJSON", stringsAsFactors=FALSE)
quakes <- recenter_points(quakes)

world_map <- fortify(world)
plates_map <- fortify(plates)
quakes_dat <- data.frame(quakes)
quakes_dat$trans <- quakes_dat$mag %% 5

gg <- ggplot()
gg <- gg + geom_cartogram(data=world_map, map=world_map,
                    aes(x=long, y=lat, map_id=id),
                    color="white", size=0.15, fill="#d8d8d6")
gg <- gg + geom_cartogram(data=plates_map, map=plates_map,
                    aes(x=long, y=lat, map_id=id),
                    color="black", size=0.1, fill="#00000000", alpha=0)
gg <- gg + geom_point(data=quakes_dat,
                      aes(x=coords.x1, y=coords.x2, size=trans),
                      shape=1, alpha=1/3, color="#d47e5d", fill="#00000000")
gg <- gg + geom_point(data=subset(quakes_dat, mag>7.5),
                      aes(x=coords.x1, y=coords.x2, size=trans),
                      shape=1, alpha=1, color="black", fill="#00000000")
gg <- gg + geom_text(data=subset(quakes_dat, mag>7.5),
                     aes(x=coords.x1, y=coords.x2, label=sprintf("Mag %2.1f", mag)),
                     color="black", size=3, vjust=c(3.9, 3.9, 5), fontface="bold")
gg <- gg + scale_size(name="Magnitude", trans="exp", labels=c(5:8), range=c(1, 20))
gg <- gg + coord_quickmap()
gg <- gg + theme_map()
gg <- gg + theme(legend.position=c(0.05, 0.99))
gg <- gg + theme(legend.direction="horizontal")
gg <- gg + theme(legend.key=element_rect(color="#00000000"))
gg