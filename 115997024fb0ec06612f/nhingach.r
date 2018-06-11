library(sp)
library(rgeos)
library(rgdal)
library(maptools)
library(tigris)

st <- states(TRUE)
nh <- st[st$NAME == "New Hampshire",]

nh_hex_pts <- sp::spsample(nh, type="hexagonal", n=10000, cellsize=0.15,
                           offset=c(0.5, 0.5), pretty=TRUE)

plot(sp::HexPoints2SpatialPolygons(nh_hex_pts))

plcs <- read.csv("nhplaces.csv", stringsAsFactors=FALSE)
