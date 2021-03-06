library(dplyr)
library(deldir)
library(sp)
library(rgdal)
library(rgeos)
library(ggplot2)
library(htmltools)
library(leaflet)

flights <- read.csv("http://bl.ocks.org/mbostock/raw/7608400/flights.csv", stringsAsFactors=FALSE)
airports <- read.csv("http://bl.ocks.org/mbostock/raw/7608400/airports.csv", stringsAsFactors=FALSE)

conus <- state.abb[!(state.abb %in% c("AK", "HI"))]

airports <- filter(airports,
                   state %in% conus,
                   iata %in% union(flights$origin, flights$destination))
orig <- select(count(flights, origin), iata=origin, n1=n)
dest <- select(count(flights, destination), iata=destination, n2=n)
airports <- left_join(airports,
                      select(mutate(left_join(orig, dest),
                                    tot=n1+n2),
                             iata, tot)) %>% 
            filter(!is.na(tot))


vor_pts <- SpatialPointsDataFrame(cbind(airports$longitude,
                                        airports$latitude),
                                  airports, match.ID=TRUE)

SPointsDF_to_voronoi_SPolysDF <- function(sp) {
 
  # tile.list extracts the polygon data from the deldir computation
  vor_desc <- tile.list(deldir(sp@coords[,1], sp@coords[,2]))
 
  lapply(1:(length(vor_desc)), function(i) {
 
    # tile.list gets us the points for the polygons but we
    # still have to close them, hence the need for the rbind
    tmp <- cbind(vor_desc[[i]]$x, vor_desc[[i]]$y)
    tmp <- rbind(tmp, tmp[1,])
 
    # now we can make the Polygon(s)
    Polygons(list(Polygon(tmp)), ID=i)
 
  }) -> vor_polygons
 
  # hopefully the caller passed in good metadata!
  sp_dat <- sp@data
 
  # this way the IDs _should_ match up w/the data & voronoi polys
  rownames(sp_dat) <- sapply(slot(SpatialPolygons(vor_polygons),
                                  'polygons'),
                             slot, 'ID')
 
  SpatialPolygonsDataFrame(SpatialPolygons(vor_polygons),
                           data=sp_dat)
 
}

vor <- SPointsDF_to_voronoi_SPolysDF(vor_pts)
 
vor_df <- fortify(vor)
 
states <- map_data("state")

url <- "http://eric.clst.org/wupl/Stuff/gz_2010_us_040_00_500k.json"
fil <- "gz_2010_us_040_00_500k.json"
 
if (!file.exists(fil)) download.file(url, fil, cacheOK=TRUE)
 
states_m <- readOGR("gz_2010_us_040_00_500k.json", 
                    "OGRGeoJSON", verbose=FALSE)
states_m <- subset(states_m, 
                   !NAME %in% c("Alaska", "Hawaii", "Puerto Rico"))
dat <- states_m@data # gSimplify whacks the data bits
states_m <- SpatialPolygonsDataFrame(gSimplify(states_m, 0.05,
                                               topologyPreserve=TRUE),
                                     dat, FALSE)

leaflet(width=900, height=650) %>%
  # base map
  addProviderTiles("Hydda.Base") %>%
  addPolygons(data=states_m,
              stroke=TRUE, color="white", weight=1, opacity=1,
              fill=TRUE, fillColor="#cccccc", smoothFactor=0.5) %>%
  # airports layer
  addCircles(data=arrange(airports, desc(tot)),
             lng=~longitude, lat=~latitude,
             radius=~sqrt(tot)*5000, # size is in m for addCircles O_o
             color="white", weight=1, opacity=1,
             fillColor="steelblue", fillOpacity=1) %>%
  # voronoi (click) layer
  addPolygons(data=vor,
              stroke=TRUE, color="#a5a5a5", weight=0.25,
              fill=TRUE, fillOpacity = 0.0,
              smoothFactor=0.5, 
              label=sprintf("Total In/Out: %s",
                            as.character(vor@data$tot)),
              labelOptions = lapply(1:nrow(vor@data), function(x) {
                 labelOptions(opacity=0.8, noHide=FALSE)
               })
              )

