library(jsonlite)
library(tigris)
library(ggplot2)
library(purrr)
library(tidyr)
library(dplyr)
library(sp)
library(rgeos)
library(rgdal)
library(maptools)
library(ggthemes)
library(viridis)

URL <- "http://graphics8.nytimes.com/newsgraphics/2016/01/15/drug-deaths/c23ba79c9c9599a103a8d60e2329be1a9b7d6994/data.json"
fil <- "epidemic.json"
if (!file.exists(fil)) download.file(URL, fil)

data <- fromJSON("epidemic.json")

drugs <- gather(data, year, value, -fips)
drugs$year <- sub("^y", "", drugs$year)
drugs <- filter(drugs, year != "2012")

qcty <- quietly(counties)

us <- qcty(setdiff(state.abb, c("AK", "HI")), cb=TRUE)$result
us <- suppressWarnings(SpatialPolygonsDataFrame(gBuffer(gSimplify(us, 0.1, TRUE), byid=TRUE, width=0), us@data))

us_map <- fortify(us, region="GEOID")

gg <- ggplot()
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", size=0, fill=NA)
gg <- gg + geom_map(data=drugs, map=us_map,
                    aes(fill=value, map_id=fips), 
                    color=NA, size=0)
gg <- gg + scale_fill_viridis(name="Overdose deaths per 100,000", 
                              option="magma")
gg <- gg + facet_wrap(~year, ncol=3)
gg <- gg + coord_map("polyconic")
gg <- gg + theme_map()
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_text(hjust=0))
gg <- gg + theme(legend.position="top")
gg

