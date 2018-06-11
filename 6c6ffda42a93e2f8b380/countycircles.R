library(rgeos)
library(rgdal) # needs gdal > 1.11.0
library(ggplot2)

# map theme
devtools::source_gist("https://gist.github.com/hrbrmstr/33baa3a79c5cfef0f6df")

# adapted from http://stackoverflow.com/questions/6862742/draw-a-circle-with-ggplot2
# computes a circle from a given diameter. we add "id" so we can have one big
# data frame and group them for plotting

circleFun <- function(id, center = c(0,0),diameter = 1, npoints = 100){
    r = diameter / 2
    tt <- seq(0,2*pi,length.out = npoints)
    xx <- center[1] + r * cos(tt)
    yy <- center[2] + r * sin(tt)
    return(data.frame(id=id, x = xx, y = yy))
}

# us topojson from the bl.ocks example
map = readOGR("us.json", "counties")

# this topojson file gives rgeos_getcentroid errors here
# so we approximate the centroid

map_df <- do.call("rbind", lapply(map@polygons, function(p) {

  b <- bbox(p)
  
  data.frame(x=b["x", "min"] + ((b["x", "max"] - b["x", "min"]) / 2),
             y=b["y", "min"] + ((b["y", "max"] - b["y", "min"]) / 2))

}))

# get area & diameter
map_df$area <- sapply(slot(map, "polygons"), slot, "area")
map_df$diameter <- sqrt(map_df$area / pi) * 2

# make our big data frame of circles

circles <- do.call("rbind", lapply(1:nrow(map_df), function(i) {
  circleFun(i, c(map_df[i,]$x, map_df[i,]$y), map_df[i,]$diameter)
}))

gg <- ggplot(data=circles, aes(x=x, y=y, group=id))
gg <- gg + geom_path(color="steelblue", size=0.25)

# continental us
gg <- gg + xlim(-124.848974, -66.885444)
gg <- gg + ylim(24.396308, 49.384358)
gg <- gg + coord_map()
gg <- gg + labs(x="", y="", title="County Circles (OK, Ovals)")
gg <- gg + theme_map()
gg <- gg + theme(legend.position="none")

ggsave("countycircles.svg", gg, width=11, height=6)