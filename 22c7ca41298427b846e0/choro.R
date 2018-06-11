library(maptools)
library(mapproj)
library(rgeos)
library(rgdal)
library(ggplot2)
library(jsonlite)
library(RCurl)

# for theme_map
devtools::source_gist("33baa3a79c5cfef0f6df")

# naturalearth world map geojson
world <- readOGR(dsn="https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_50m_admin_0_countries.geojson", layer="OGRGeoJSON")

# remove antarctica
world <- world[!world$iso_a3 %in% c("ATA"),]

world <- spTransform(world, CRS("+proj=wintri"))

dat_url <- getURL("https://gist.githubusercontent.com/hrbrmstr/7a0ddc5c0bb986314af3/raw/6a07913aded24c611a468d951af3ab3488c5b702/pop.csv")
pop <- read.csv(text=dat_url, stringsAsFactors=FALSE, header=TRUE)

map <- fortify(world, region="iso_a3")

labs <- data.frame(lat=c(39.5, 35.50), 
                   lon=c(-98.35, 103.27), 
                   title=c("US", "China"))
coordinates(labs) <-  ~lon+lat
c_labs <- as.data.frame(SpatialPointsDataFrame(spTransform(
  SpatialPoints(labs, CRS("+proj=longlat")), CRS("+proj=wintri")),
  labs@data))

gg <- ggplot()
gg <- gg + geom_map(data=map, map=map,
                    aes(x=long, y=lat, map_id=id, group=group),
                    fill="#ffffff", color=NA)
gg <- gg + geom_map(data=pop, map=map, color="white", size=0.15,
                    aes(fill=log(X2013), group=Country.Code, map_id=Country.Code))
gg <- gg + geom_text(data=c_labs, aes(x=lon, y=lat, label=title))
gg <- gg + scale_fill_gradient(low="#f7fcb9", high="#31a354", name="Population by Country\n(2013, log scale)")
gg <- gg + labs(title="2013 Population")
# much better projection for US maps
gg <- gg + coord_equal(ratio=1)
gg <- gg + theme_map()
gg <- gg + theme(legend.position="bottom")
gg <- gg + theme(legend.key = element_blank())
gg <- gg + theme(plot.title=element_text(size=16))
gg
