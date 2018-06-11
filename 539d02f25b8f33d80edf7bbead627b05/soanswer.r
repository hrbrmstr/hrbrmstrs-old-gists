library(rgdal)
library(rgeos)
library(maptools)
library(ggplot2)
library(ggthemes)
library(viridis)

canada <- readOGR("canada.geojson", "OGRGeoJSON", 
                  verbose=FALSE, stringsAsFactors=FALSE)
usa <- readOGR("usacounties.geojson", "OGRGeoJSON", 
               verbose=FALSE, stringsAsFactors=FALSE)

ca_map <- fortify(canada, region="CDUID")
us_map <- fortify(usa, region="CO99_D90_I")

set.seed(1492)
ca_pop <- data.frame(id=unique(canada$CDUID),
                     val=sample(100000, length(unique(canada$CDUID))),
                     stringsAsFactors=FALSE)
us_pop <- data.frame(id=unique(usa$CO99_D90_I),
                     val=sample(100000, length(unique(usa$CO99_D90_I))),
                     stringsAsFactors=FALSE)

gg <- ggplot()
gg <- gg + geom_map(data=ca_map, map=ca_map,
                    aes(long, lat, map_id=id),
                    size=0.1, fill=NA, color="#2b2b2b")
gg <- gg + geom_map(data=ca_pop, map=ca_map,
                    aes(fill=val, map_id=id))
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(long, lat, map_id=id),
                    size=0.1, fill=NA, color="#2b2b2b")
gg <- gg + geom_map(data=us_pop, map=us_map,
                    aes(fill=val, map_id=id))
gg <- gg + scale_fill_viridis(name="Population")
gg <- gg + coord_map(xlim=c(-170, -55), ylim=c(23.2, 80))
gg <- gg + theme_map()
gg