library(rgdal)
library(rgeos)
library(ggplot2)
library(maptools)
library(dplyr)
library(purrr)
library(ggthemes)

# read in the shapefile
fires <- readOGR("us_historic_fire_perimeters_dd83/us_historic_fire_perimeters_dd83.shp", 
                 "us_historic_fire_perimeters_dd83", 
                 stringsAsFactors=FALSE)

# simplify the polygons (the source shapefile is >100MB with intricate polygon)
fires <- SpatialPolygonsDataFrame(gSimplify(fires, 0.1, TRUE), fires@data)

# in the event we want to facet by year, build a fortified
# data frame for ggplot2 with that data
map_df(unique(fires@data$year_), function(x) {
  fortify(subset(fires, year_==x)) %>% 
    mutate(year=x, id=sprintf("%s-%s", year, id)) 
}) -> fires_df

# base map
us <- map_data("usa")

gg <- ggplot()
gg <- gg + geom_map(data=us, map=us,
                    aes(long, lat, map_id=region),
                    color="#2b2b2b", size=0.1, fill="#2b2b2b")
gg <- gg + geom_map(data=fires_df, map=fires_df,
                    aes(long, lat, map_id=id),
                    color="#00000000", size=0.1, fill="#ef3b2c", alpha=1/4)
gg <- gg + coord_map("polyconic", xlim=c(-125, -70), ylim=c(25, 50))
gg <- gg + labs(title="Historic ConUS Fires (2000-2016)",
                caption="Source: http://rmgsc.cr.usgs.gov/outgoing/GeoMAC/historic_fire_data/\ngist: https://gist.github.com/hrbrmstr/5d461857b40e2ad5558d769f2de00174")
gg <- gg + theme_map(base_family="Arial Narrow")
gg <- gg + theme(panel.background=element_rect(fill="#b2b2b2", color="#b2b2b2"))
gg <- gg + theme(plot.title=element_text(face="bold", size=16))
gg

