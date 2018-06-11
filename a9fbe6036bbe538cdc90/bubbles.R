library(maptools)
library(mapproj)
library(rgeos)
library(rgdal)
library(ggplot2)

# for theme_map
devtools::source_gist("33baa3a79c5cfef0f6df")

# nice US map GeoJSON
us <- readOGR(dsn="http://eric.clst.org/wupl/Stuff/gz_2010_us_040_00_500k.json", layer="OGRGeoJSON")

# even smaller polygons
us <- SpatialPolygonsDataFrame(gSimplify(us, tol=0.1, topologyPreserve=TRUE), 
                               data=us@data)

# don't need these for the continental base map
us <- us[!us$NAME %in% c("Alaska", "Hawaii", "Puerto Rico", "District of Columbia"),]

# for ggplot
map <- fortify(us, region="NAME")

# your data
myData <- data.frame(name=c("Florida", "Colorado", "California", "Harvard", "Yellowstone"),
                     lat=c(28.1, 39, 37, 42, 44.6), 
                     long=c(-81.6, -105.5, -120, -71,-110),
                     pop=c(280, 156, 128, 118, 202))

# the map

gg <- ggplot()
# the base map
gg <- gg + geom_map(data=map, map=map,
                    aes(x=long, y=lat, map_id=id, group=group),
                    fill="#ffffff", color="#0e0e0e", size=0.15)
# your bubbles
gg <- gg + geom_point(data=myData, 
                      aes(x=long, y=lat, size=pop), color="#AD655F")
gg <- gg + scale_size_continuous(name="Populatiobn")
gg <- gg + labs(title="Bubbles")
# much better projection for US maps
gg <- gg + coord_map(projection="albers", lat=39, lat1=45)
gg <- gg + theme_map()
gg <- gg + theme(legend.position="bottom")
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(plot.title=element_text(size=16))
gg
