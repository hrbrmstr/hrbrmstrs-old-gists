library(XML)
library(maptools)
library(sp)
library(plyr)

# Small script to get county-level outage info from Bangor Hydro
# Electric's town(-ish) level info
#
# BHE's outage google push-pin map is at
#   http://apps.bhe.com/about/outages/outage_map.cfm

# read BHE outage XML file that was intended for the google map
# yep. One. Line. #takethatpython

doc <- xmlTreeParse("http://apps.bhe.com/about/outages/outage_map.xml", 
                    useInternalNodes=TRUE)

# xmlToDataFrame() coughed up blood on that simple file, so we have to
# resort to menial labor to bend the XML to our will

doc.ls <- xmlToList(doc)
doc.attrs <- doc.ls$.attrs
doc.ls$.attrs <- NULL

# this does the data frame conversion magic, tho it winces a bit

suppressWarnings(doc.df <- data.frame(do.call(rbind, doc.ls), 
                                      stringsAsFactors=FALSE))

# need numbers for some of the columns (vs strings)

doc.df$outages <- as.numeric(doc.df$outages)
doc.df$lat <- as.numeric(doc.df$lat)
doc.df$lng <- as.numeric(doc.df$lng)

# SpatialPoints likes matrices, note that it's in LON, LAT order
# that always messes me up for some reason

doc.m <- as.matrix(doc.df[,c(4,3)])
doc.pts <- SpatialPoints(doc.m)

# I trimmed down the country-wide counties file from
#   http://www.baruch.cuny.edu/geoportal/data/esri/usa/census/counties.zip
# with
#   ogr2ogr -f "ESRI Shapefile" -where "STATE_NAME = 'MAINE'" maine.shp counties.shp
# to both save load time and reduce the number of iterations for over() later

counties <- readShapePoly("maine.shp", repair=TRUE, IDvar="NAME")

# So, all the above was pretty much just for this next line which does  
# the "is this point 'a' in polygon 'b' automagically for us. 

found.pts <- over(doc.pts, counties)

# steal the column we need (county name) and squirrel it away with outage count

doc.df$county <- found.pts$NAME
doc.sub <- doc.df[,c(2,7)]

# aggregate the result to get outage count by county

count(doc.sub, c("county"), wt_var="outages")

# where are the unresolved points?
doc.df[is.na(doc.df$county),c(1:4)]

# i only really want the data, but maps are spiffy. let's build our
# own (i.e. not-google-y) map, keeping the "dots"

library(ggplot2)

ff = fortify(counties, region = "NAME")

# first, look at the "missing" points

missing <- doc.df[is.na(doc.df$county),]

gg <- ggplot(ff, aes(x = long, y = lat))
gg <- gg + geom_path(aes(group = group), size=0.15, fill="black")
gg <- gg + geom_point(data=missing, aes(x=lng, y=lat), 
                      color="#feb24c", size=3)
gg <- gg + coord_map(xlim=extendrange(range(missing$lng)), ylim=extendrange(range(missing$lat)))
gg <- gg + theme_bw()
gg <- gg + labs(x="", y="")
gg <- gg + theme(plot.background = element_rect(fill = "transparent",colour = NA),
                 panel.border = element_blank(),
                 panel.background =element_rect(fill = "transparent",colour = NA),
                 panel.grid = element_blank(),
                 axis.text = element_blank(),
                 axis.ticks = element_blank(),
                 legend.position="right",
                 legend.title=element_blank())
gg

# now get a full overview map

gg <- ggplot(ff, aes(x = long, y = lat))
gg <- gg + geom_polygon(aes(group = group), size=0.15, fill="black", color="#7f7f7f")
gg <- gg + geom_point(data=doc.df, aes(x=lng, y=lat, alpha=outages, size=outages), 
                      color="#feb24c")
gg <- gg + coord_map(xlim=c(-71.5,-66.75), ylim=c(43,47.5))
gg <- gg + theme_bw()
gg <- gg + labs(x="", y="")
gg <- gg + theme(plot.background = element_rect(fill = "transparent",colour = NA),
                 panel.border = element_blank(),
                 panel.background =element_rect(fill = "transparent",colour = NA),
                 panel.grid = element_blank(),
                 axis.text = element_blank(),
                 axis.ticks = element_blank(),
                 legend.position="right",
                 legend.title=element_blank())
gg