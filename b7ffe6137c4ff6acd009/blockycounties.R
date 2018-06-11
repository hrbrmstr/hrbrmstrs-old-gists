library(rgeos)
library(rgdal) # needs gdal > 1.11.0
library(ggplot2)

# map theme
devtools::source_gist("https://gist.github.com/hrbrmstr/33baa3a79c5cfef0f6df")

# use the topojson from the bl.ocks example
map = readOGR("us.json", "counties")

# build our map data frame of rects

map_df <- do.call("rbind", lapply(map@polygons, function(p) {

  b <- bbox(p) # get bounding box of polygon and put it into a form we can use later

  data.frame(xmin=b["x", "min"],
             xmax=b["x", "max"],
             ymin=b["y", "min"],
             ymax=b["y", "max"])

}))
map_df$id <- map$id # add the id even though we aren't using it now

gg <- ggplot(data=map_df)
gg <- gg + geom_rect(aes(xmin=xmin, xmax=xmax,
                         ymin=ymin, ymax=ymax),
                     color="steelblue", alpha=0, size=0.25)

# continental us only
gg <- gg + xlim(-124.848974, -66.885444)
gg <- gg + ylim(24.396308, 49.384358)
gg <- gg + coord_map()
gg <- gg + labs(x="", y="", title="Blocky Counties")
gg <- gg + theme_map()
gg <- gg + theme(legend.position="none")

ggsave("blockycounties.svg", gg, width=11, height=6)