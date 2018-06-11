library(sp)
library(maptools)
library(rgeos)
library(rgdal)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(ggalt)

URL <- "http://census.edina.ac.uk/ukborders/easy_download/prebuilt/shape/England_gor_2011.zip"
fil <- basename(URL)
if (!file.exists(fil)) download.file(URL, fil)

fils <- unzip(fil)
shp <- grep("shp$", fils, value=TRUE)

region <- readOGR(shp, ogrListLayers(shp)[1], stringsAsFactors=FALSE)
region@data$Region <- c("East", "South & S.E", "North", "North", "Midlands", 
                        "North", "SouthWest", "Midlands", "South & S.E")
colnames(region@data) <- c("code", "name","Region")

regions <- unionSpatialPolygons(region, region@data$Region)
regions <- gSimplify(regions, 100, topologyPreserve=TRUE)
regions <- gBuffer(regions, byid=TRUE, width=0)

regions <- SpatialPolygonsDataFrame(spTransform(regions,
                                                CRS("+proj=longlat +ellps=sphere +no_defs")),
                                    data.frame(Region=names(regions),
                                               row.names=names(regions),
                                               stringsAsFactors=FALSE))

eng_map <- fortify(regions, region="Region")
eng_proj <- "+proj=aea +lat_0=54.55635146083455 +lon_0=-3.076171875"

ggplot() + 
  geom_map(data=eng_map, map=eng_map,
           aes(x=long, y=lat, map_id=id),
           color=NA, fill=NA, size=0.5) +
  geom_map(data=data.frame(id=unique(eng_map$id)), map=eng_map, 
           aes(map_id=id, fill=id),
           color="white", size=0.15) +
  scale_fill_brewer(palette="Set2") +
  coord_proj(eng_proj) +
  theme_map() +
  theme(legend.position="right")
