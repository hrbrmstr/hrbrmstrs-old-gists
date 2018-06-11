library(xml2)
library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(maptools)
library(sp)

# inspired by this SCADACS post: http://www.scadacs.org/iram.html
# 
# ... except that you'll need to use the wayback machine to see that since they
# seem to have removed all traces of it from their site. #howrude
# 
# it's a good thing i'm a packrat
#
# and this is much better R code

# get the data
URL <- "http://rud.is/dl/risk_v2.kmz"
fil <- basename(URL)
if (!file.exists(fil)) download.file(URL, fil)
dat <- unzip("risk_v2.kmz")

# read it in 
risk_kml <- read_xml(dat)
ns <- xml_ns_rename(xml_ns(risk_kml), d1 = "k")

# extract salient info from the XML file
color <- xml_text(xml_find_all(risk_kml, "//k:Folder/k:Document/k:Placemark/k:Style/k:IconStyle/k:color", ns=ns))
color <- sprintf("#%s", color)
coords <- xml_text(xml_find_all(risk_kml, "//k:Folder/k:Document/k:Placemark/k:Point/k:coordinates", ns=ns))

# clean it up a bit
risk <- data_frame(color, coords)
risk <- separate(risk, coords, c("long", "lat", "elev"), sep=",", convert=TRUE)
risk <- select(risk, long, lat, color)
risk <- data.frame(risk, stringsAsFactors=FALSE)

# only care about united states values for this vis
us_risk <- risk
us_map <- map("state", col="transparent", plot=FALSE, fill=TRUE)
us_map <- map2SpatialPolygons(us_map, IDs=us_map$names, proj4string=CRS("+proj=longlat +datum=WGS84"))
coordinates(risk) <- ~long+lat
proj4string(risk) <- CRS("+proj=longlat +datum=WGS84")
us_risk <- data.frame(us_risk[which(!is.na(risk %over% us_map)),], stringsAsFactors=FALSE)

# do the vis thing
us <- map_data("state")

gg <- ggplot()
gg <- gg + geom_map(data=us, map=us,
                    aes(x=long, y=lat, map_id=region),
                    color="white", fill="grey10", size=0.15)
gg <- gg + geom_point(data=us_risk, 
                      aes(x=long, y=lat), colour=I(us_risk$color), 
                      alpha=1/10, size=1.0)
gg <- gg + coord_map("albers", lat0=39, lat1=45)
gg <- gg + theme_map()
gg