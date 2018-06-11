library(sp)
library(rgdal)
library(deldir)
library(dplyr)
library(ggplot2)
library(ggthemes)

# Re-creating http://bl.ocks.org/mbostock/7608400 (somewhat)

# Take a set of points and return a set of Voronoi polygons ---------------
SPointsDF_to_voronoi_SPolysDF <- function(sp) {

  vor_desc <- tile.list(deldir(sp@coords[,1], sp@coords[,2]))

  lapply(1:(length(vor_desc)), function(i) {

    # tile.list gets us the points for the polygons
    # but we still have to close them, hence the
    # need for the rbind. I rly wish Polygon wld
    # take a data.frame

    tmp <- cbind(vor_desc[[i]]$x, vor_desc[[i]]$y)
    tmp <- rbind(tmp, tmp[1,])

    # now we can make the Polygon(s)

    Polygons(list(Polygon(tmp)), ID=i)

  }) -> vor_polygons

  # hopefully the caller passed in good metadata!
  sp_dat <- sp@data

  # this way the IDs _should_ match up w/the data & voronoi polys
  rownames(sp_dat) <- sapply(slot(SpatialPolygons(vor_polygons), 'polygons'),
                             slot, 'ID')

  SpatialPolygonsDataFrame(SpatialPolygons(vor_polygons),
                           data=sp_dat)

}

# It’s easier just to work with the CONUS (with Apologies to AK/HI)
conus <- state.abb[!(state.abb %in% c("AK", "HI"))]

# [ab]use the example inspiration data
flights <- read.csv("http://bl.ocks.org/mbostock/raw/7608400/flights.csv", stringsAsFactors=FALSE)
airports <- read.csv("http://bl.ocks.org/mbostock/raw/7608400/airports.csv", stringsAsFactors=FALSE)

# only care abt CONUS airports + ones mentioned in "flights" dataset
airports <- filter(airports,
                   state %in% conus,
                   iata %in% union(flights$origin, flights$destination))
orig <- select(count(flights, origin), iata=origin, n1=n)
dest <- select(count(flights, destination), iata=destination, n2=n)
airports <- left_join(airports,
                      select(mutate(left_join(orig, dest),
                                    tot=n1+n2),
                             iata, tot))

# now we need the points from our reifined data set so we can
# compute Voronoi polygons
pts <- cbind(airports$longitude, airports$latitude)
dimnames(pts)[[1]] <- rownames(airports)

vor_pts <- SpatialPointsDataFrame(pts, airports, match.ID=TRUE)
vor <- SPointsDF_to_voronoi_SPolysDF(vor_pts)

# for ggplot
vor_df <- fortify(vor)

# base map
states <- map_data("state")

gg <- ggplot()
# base map
gg <- gg + geom_map(data=states, map=states,
                    aes(x=long, y=lat, map_id=region),
                    color="white", fill="#cccccc", size=0.5)
# airports layer
gg <- gg + geom_point(data=airports,
                      aes(x=longitude, y=latitude, size=tot),
                      shape=21, color="white", fill="steelblue")
# voronoi layer
gg <- gg + geom_map(data=vor_df, map=vor_df,
                    aes(x=long, y=lat, map_id=id),
                    color="#a5a5a5", fill="#FFFFFF00", size=0.25)
gg <- gg + scale_size(range=c(3,9))
gg <- gg + coord_map("albers", lat0=30, lat1=40)
gg <- gg + theme_map()
gg <- gg + theme(legend.position="none")
gg
