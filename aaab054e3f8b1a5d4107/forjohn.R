
# 1 -----------------------------------------------------------------------

library(maps)
map("state")

# 2 -----------------------------------------------------------------------

library(ggplot2)
library(ggthemes)
 
states <- map_data("state")
 
gg <- ggplot()
gg <- gg + geom_map(data=states, map=states,
                    aes(x=long, y=lat, map_id=region),
                    color="black", fill="white", size=0.25)
gg <- gg + theme_map()
gg

# 3 -----------------------------------------------------------------------

library(mapproj)
map("state", projection="albers", par=c(lat0=30, lat1=40))

# 4 -----------------------------------------------------------------------

gg + coord_map()

# 5 -----------------------------------------------------------------------

gg + coord_map("albers", lat0=30, lat1=40)

# 6 -----------------------------------------------------------------------

library(sp)
library(rworldmap) # this pkg has waaaay better world shapefiles
 
plot(spTransform(getMap(), CRS("+proj=wintri")))

# 7 -----------------------------------------------------------------------

library(rgdal) # for readOGR
library(httr)  # for downloading
 
launch_sites <- paste0("https://collaborate.org/sites/collaborate.org/",
                       "files/spacecentersnon-militaryspacelaunchsites.kml")
invisible(try(GET(launch_sites, write_disk("/tmp/launch-sites.kml")), silent=TRUE))
 
sites <- readOGR("/tmp/launch-sites.kml", 
                 "SpaceCenters: Non-Military Space Launch Sites", 
                 verbose=FALSE)
sites_wt <- spTransform(sites, CRS("+proj=wintri"))
sites_wt <- coordinates(sites_wt)
 
gg <- gg + geom_point(data=as.data.frame(sites_wt), 
                      aes(x=coords.x1, y=coords.x2), 
                      color="#b2182b")
gg

# 8 -----------------------------------------------------------------------

world <- fortify(getMap())
sites <- as.data.frame(coordinates(readOGR("/tmp/launch-sites.kml", 
                                           "SpaceCenters: Non-Military Space Launch Sites", 
                                           verbose=FALSE)))
 
gg <- ggplot()
gg <- gg + geom_map(data=world, map=world,
                    aes(x=long, y=lat, map_id=id),
                    color="black", fill="white", size=0.25)
gg <- gg + geom_point(data=(sites), 
                      aes(x=coords.x1, y=coords.x2), 
                      color="#b2182b")
gg <- gg + coord_proj("+proj=wintri")
gg <- gg + theme_map()
gg

# 9 -----------------------------------------------------------------------

gg + coord_proj("+proj=cea +lat_ts=37.5")


