library(ggplot2)
library(ggmap)
library(plyr)
library(grid)
library(gridExtra)

# read in cleaned up data
dat <- read.table("quakes.dat", header=TRUE, stringsAsFactors=FALSE)

# map decimal magnitudes into an integer range
dat$m <- cut(dat$MAG, c(0:10))

# convert to dates
dat$DATE <- as.Date(dat$DATE)

# so we can re-order the data frame
dat <- dat[order(dat$DATE),]

# not 100% necessary, but get just the numeric portion of the cut factor
dat$Magnitude <- factor(as.numeric(dat$m))

# sum up by date for the barplot
dat.sum <- count(dat, .(DATE, Magnitude))

# start the ggmap() bit
# It's super-handy that it understands things like "Los Angeles" #spoffy
# I like the 'toner' version. Would also use a stamen map but I can't get 
# to it consistently from behind a proxy server
la <- get_map(location="Los Angeles", zoom=10, color="bw", maptype="toner")

# get base map layer
gg <- ggmap(la) 

# add points. Note that the plot will produce warnings for all points not in the
# lat/lon range of the base map layer. Also note that i'm encoding magnitude by
# size and color and using alpha for depth. because of the way the data is sorted
# the most recent quakes in the set should be on top
gg <- gg + geom_point(data=dat,
                      mapping=aes(x=LON, y=LAT, 
                                  size=MAG, fill=m, alpha=DEPTH), shape=21, color="black")

# this takes the magnitude domain and maps it to a better range of values (IMO)
gg <- gg + scale_size_continuous(range=c(1,15))

# this bit makes the right size color ramp. i like the reversed view better for this map
gg <- gg + scale_fill_manual(values=rev(terrain.colors(length(levels(dat$Magnitude)))))
gg <- gg + ggtitle("Recent Earthquakes in CA & NV")

# no need for a legend as the bars are pretty much the legend
gg <- gg + theme(legend.position="none")

# now for the bars. we work with the summarized data frame
gg.1 <- ggplot(dat.sum, aes(x=DATE, y=freq, group=Magnitude))

# normally, i dislike stacked bar charts, but this is one time i think they work well
gg.1 <- gg.1 + geom_bar(aes(fill=Magnitude), position="stack", stat="identity")

# fancy, schmanzy color mapping again
gg.1 <- gg.1 + scale_fill_manual(values=rev(terrain.colors(length(levels(dat$Magnitude)))))

# show the data source!
gg.1 <- gg.1 + labs(x="Data from: http://www.data.scec.org/recent/recenteqs/Maps/Los_Angeles.html", y="Quake Count")
gg.1 <- gg.1 + theme_bw()

# use grid.arrange to make the sizes work well
grid.arrange(gg, gg.1, nrow=2, ncol=1, heights=c(3,1))
