library(sp)
library(rgeos)
library(rgdal)
library(ggplot2)
library(ggalt)
library(maptools)
library(dplyr)

ne <- readOGR(path.expand("~/Data/geo/New-England-counties/newengland_topo.json"), "counties")
ne_map <- fortify(ne, region="id")

res <- GET(url="https://maine-outages-ms.esri.com/arcgis/rest/services/CMPOutageMap_v2/MapServer/0/query", 
           query=list(f="json", 
                      where="Company = 'CMP' AND NumOut > 0", 
                      returnGeometry="true", 
                      geometryType="esriGeometryEnvelope", 
                      inSR="102100", 
                      outFields="*", 
                      outSR="102100"),
           add_headers(Origin="http://outagemap.cmpco.com", 
                       Referer="http://outagemap.cmpco.com/cmp/"), 
           encode = "form")

dat <- fromJSON(content(res, as="text"))

df <- dat$features$geometry
coordinates(df) <- ~x+y
proj4string(df) <- CRS(sprintf("+init=epsg:%s", dat$spatialReference$latestWkid))

places <- spTransform(df, "+proj=longlat +ellps=WGS84 +datum=WGS84")
bb <- bbox(places)
places <- as.data.frame(places)
places <- bind_cols(places, dat$features$attributes)
places <- mutate(places, NumOutb=cut(NumOut, breaks=seq(0, 1000, 100)))

ggplot() +
  geom_map(data=ne_map, map=ne_map, aes(long, lat, map_id=id), color="#2b2b2b", size=0.1, fill=NA) +
  geom_point(data=places, aes(x, y, fill=NumOutb), shape=21) +
  coord_proj(xlim=scales::expand_range(bb[1,], 6), 
             ylim=scales::expand_range(bb[2,], 6)) +
  scale_fill_brewer(name="# Impacted", palette="Purples") +
  ggthemes::theme_map() +
  theme(legend.position="right")

places
