library(ggplot2)
library(maptools)
library(ggthemes)
library(rgdal)
library(rgeos)
library(dplyr)
library(stringi)

# get your data
ncftrendsort <- read.csv("mdrdata.csv", sep=" ", stringsAs=FALSE)

# get a decent US map
url <- "http://eric.clst.org/wupl/Stuff/gz_2010_us_040_00_500k.json"
fil <- "states.json"
if (!file.exists(fil)) download.file(url, fil)

# read in the map
us <- readOGR(fil, "OGRGeoJSON", stringsAsFactors=FALSE)
# filter out what you don't need
us <- us[!(us$NAME %in% c("Alaska", "Hawaii", "Puerto Rico")),]
# make it easier to merge
us@data$NAME <- tolower(us@data$NAME)

# clean up your broken data
ncftrendsort <- mutate(ncftrendsort,
                       region=ifelse(region=="washington, dc",
                                     "district of columbia",
                                     region))
ncftrendsort <- mutate(ncftrendsort,
                       region=ifelse(region=="louisana",
                                     "louisiana",
                                     region))
ncftrendsort <- filter(ncftrendsort, region != "hawaii")

# merge with the us data so we can combine the regions
us@data <- merge(us@data,
                 distinct(ncftrendsort, region, Region),
                 by.x="NAME", by.y="region", all.x=TRUE, sort=FALSE)

# region union kills the data frame so save it
tmp <- us@data
regs <- gUnaryUnion(us, us@data$Region)
# takes way to long to plot without similifying the polygons
regs <- gSimplify(regs, 0.05, topologyPreserve = TRUE)
# associate the polygons to the names properly
nc_regs <- distinct(us@data, Region)
regs <- SpatialPolygonsDataFrame(regs, nc_regs[c(2,1,4,5,3,6),], match.ID=FALSE)

# get region centroids and add what color the text should be and
# specify only the first year range so it only plots on one facet
reg_labs <- mutate(add_rownames(as.data.frame(gCentroid(regs, byid = TRUE)), "Region"),
                   Region=gsub(" ", "\n", stri_trans_totitle(Region)),
                   Years="1999-2003", color=c("black", "black", "white",
                                              "black", "black", "black"))

# make it ready for ggplot
us_reg <- fortify(regs, region="Region")

# get outlines for states and
# specify only the first year range so it only plots on one facet
outlines <- map_data("state")
outlines$Years <- "1999-2003"

gg <- ggplot()
# base map
# gg <- gg + geom_map(data=us_reg, map=us_reg,
#                     aes(x=long, y=lat, map_id=id),
#                     color="black", fill="white", alpha=0)
# filled regions
gg <- gg + geom_map(data=ncftrendsort, map=us_reg,
                    aes(fill=mdr, map_id=Region),
                    color="black", size=0.5)
gg <- gg + geom_map(data=outlines, map=outlines,
                    aes(x=long, y=lat, map_id=region),
                    fill="#000000", color="#7f7f7f",
                    linetype="dotted", size=0.25, alpha=0)
gg <- gg + geom_text(data=reg_labs, aes(x=x, y=y, label=Region),
                     color=reg_labs$color, size=4)
gg <- gg + scale_fill_continuous(name="% MDR", low='white', high='black')
gg <- gg + labs(title="Regional Multi-Drug Resistant PSA\n(non-CF Patients), 1999-2012")
gg <- gg + facet_grid(Years~.)
# you really should use a projection
gg <- gg + coord_map("albers", lat0=39, lat1=45)
gg <- gg + theme_map()
gg <- gg + theme(plot.title=element_text(size=13, vjust=2))
gg <- gg + theme(legend.position="right")
# get rid of slashes
gg <- gg + guides(fill=guide_legend(override.aes=list(colour=NA)))
gg

