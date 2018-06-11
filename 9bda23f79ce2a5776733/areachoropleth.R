library(rgeos)
library(rgdal) # needs gdal > 1.11.0
library(ggplot2)

# map theme
devtools::source_gist("https://gist.github.com/hrbrmstr/33baa3a79c5cfef0f6df")

# topojson from the bl.ocks example
map = readOGR("us.json", "counties")

# calculate (retrieve) area
map_area <- data.frame(id=0:(length(map@data$id)-1),
                       area=sapply(slot(map, "polygons"), slot, "area") )

# state borders
states = readOGR("us.json", "states")
states_df <- fortify(states)

# create map data frame and merge area info
map_df <- fortify(map)
map_df <- merge(map_df, map_area, by="id")

gg <- ggplot()
gg <- gg + geom_map(data=map_df, map=map_df,
                    aes(map_id=id, x=long, y=lat, group=group, fill=log1p(area)),
                    color="white", size=0.05)
gg <- gg + geom_map(data=states_df, map=states_df,
                    aes(map_id=id, x=long, y=lat, group=group),
                    color="white", size=0.5, alpha=0)
gg <- gg + scale_fill_continuous(low="#ccebc5", high="#084081")

# US continental extents - not showing alaska & hawaii
gg <- gg + xlim(-124.848974, -66.885444)
gg <- gg + ylim(24.396308, 49.384358)

gg <- gg + coord_map()
gg <- gg + labs(x="", y="", title="Area Choropleth")
gg <- gg + theme_map()
gg <- gg + theme(legend.position="none")

ggsave("areachoropleth.svg", gg, width=11, height=6)

