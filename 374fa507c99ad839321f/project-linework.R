#+ cache=TRUE, message=FALSE

suppressPackageStartupMessages(library(rgdal))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(ggthemes))
suppressPackageStartupMessages(library(gridExtra))
suppressPackageStartupMessages(library(maptools))
# devtools::install_github("hrbrmstr/lineworkmaps")
suppressPackageStartupMessages(library(lineworkmaps))


#' ### Elmer Casual
#+ cache=TRUE, message=FALSE

elmer <- linework_map("elmer_casual")
us <- elmer[elmer$COUNTRY=="US" & elmer$Name != "Alaska",]
us_outline <- unionSpatialPolygons(us, IDs=row.names(us))
us_map <- fortify(us)
us_outline_map <- fortify(us_outline)
gg <- ggplot()
gg <- gg + geom_map(data=us_outline_map, map=us_outline_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#a5c3d1", fill="#ffffff00", size=4)
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#939598", fill="#d1d2d4", size=0.5)
gg <- gg + coord_map(project="albers", lat0=37.5, lat1=29.5)
gg <- gg + labs(title="Elmer Casual")
gg <- gg + theme_map()
gg <- gg + theme(plot.title=element_text(size=16))
elmer_map <- gg

#' ### Charmingly Inaccurate
#+ cache=TRUE, message=FALSE

charming <- linework_map("charmingly_inaccurate")
us_outline <- unionSpatialPolygons(charming, IDs=row.names(charming))
us_map <- fortify(charming)
us_outline_map <- fortify(us_outline)
gg <- ggplot()
gg <- gg + geom_map(data=us_outline_map, map=us_outline_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#a5c3d1", fill="#ffffff00", size=4)
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#939598", fill="#d1d2d4", size=0.5)
gg <- gg + coord_map(project="albers", lat0=37.5, lat1=29.5)
gg <- gg + labs(title="Charmingly Inaccurate")
gg <- gg + theme_map()
gg <- gg + theme(plot.title=element_text(size=16))
charming_map <- gg

#' ### Geo-Metro
#+ cache=TRUE, message=FALSE

geo_metro <- linework_map("geo_metro")
us <- geo_metro[geo_metro$COUNTRY=="US" & geo_metro$NAME != "Alaska",]
us_outline <- unionSpatialPolygons(us, IDs=row.names(us))
us_map <- fortify(us)
us_outline_map <- fortify(us_outline)
gg <- ggplot()
gg <- gg + geom_map(data=us_outline_map, map=us_outline_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#a5c3d1", fill="#ffffff00", size=4)
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#939598", fill="#d1d2d4", size=0.5)
gg <- gg + coord_map(project="albers", lat0=37.5, lat1=29.5)
gg <- gg + labs(title="Geo-Metro")
gg <- gg + theme_map()
gg <- gg + theme(plot.title=element_text(size=16))
geometro_map <- gg

#' ### Times Approximate
#+ cache=TRUE, message=FALSE

times <- linework_map("times_approximate")
us_outline <- unionSpatialPolygons(times, IDs=row.names(times))
us_map <- fortify(times)
us_outline_map <- fortify(us_outline)
gg <- ggplot()
gg <- gg + geom_map(data=us_outline_map, map=us_outline_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#a5c3d1", fill="#ffffff00", size=4)
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#939598", fill="#d1d2d4", size=0.5)
gg <- gg + coord_map(project="albers", lat0=37.5, lat1=29.5)
gg <- gg + labs(title="Times Approximate")
gg <- gg + theme_map()
gg <- gg + theme(plot.title=element_text(size=16))
times_map <- gg

#' ### Twenty Seventy
#+ cache=TRUE, message=FALSE

twenty <- linework_map("twenty_seventy")
us <- twenty[twenty$Country=="US" & !twenty$Name %in% c("Alaska"),]
us_outline <- unionSpatialPolygons(us, IDs=row.names(us))
us_map <- fortify(us)
us_outline_map <- fortify(us_outline)
gg <- ggplot()
gg <- gg + geom_map(data=us_outline_map, map=us_outline_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#a5c3d1", fill="#ffffff00", size=4)
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#939598", fill="#d1d2d4", size=0.5)
gg <- gg + coord_map(project="albers", lat0=37.5, lat1=29.5)
gg <- gg + labs(title="Twenty Seventy")
gg <- gg + theme_map()
gg <- gg + theme(plot.title=element_text(size=16))
twenty_map <- gg

#' ### Wargames
#+ cache=TRUE, message=FALSE

wargames <- linework_map("wargames")
us <- wargames[wargames$iso_a2=="US" & !wargames$code_hasc %in% c("US.HI", "US.AK"),]
us_outline <- unionSpatialPolygons(us, IDs=row.names(us))
us_map <- fortify(us)
us_outline_map <- fortify(us_outline)
gg <- ggplot()
gg <- gg + geom_map(data=us_outline_map, map=us_outline_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#a5c3d1", fill="#ffffff00", size=4)
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#939598", fill="#d1d2d4", size=0.5)
gg <- gg + coord_map(project="albers", lat0=37.5, lat1=29.5)
gg <- gg + labs(title="Wargames")
gg <- gg + theme_map()
gg <- gg + theme(plot.title=element_text(size=16))
wargames_map <- gg

#' ### Make It So
#+ plots, fig.width=12, fig.height=12, fig.retina=2
grid.arrange(elmer_map, charming_map, geometro_map,
             times_map, twenty_map, wargames_map,
             ncol=2)

#' <hr noshade size="1"/>
#' You can grab all the shapefiles from [Project Linework](http://www.projectlinework.org/)
