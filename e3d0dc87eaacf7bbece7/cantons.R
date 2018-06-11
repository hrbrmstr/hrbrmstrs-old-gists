library(rgeos)
library(rgdal) # needs gdal > 1.11.0
library(ggplot2)

# map theme
devtools::source_gist("https://gist.github.com/hrbrmstr/33baa3a79c5cfef0f6df")

map = readOGR("readme-swiss.json", "cantons")
map_df <- fortify(map)

#  create mapping for id # to name since "region=" won't work
dat <- data.frame(id=0:(length(map@data$name)-1), canton=map@data$name)
map_df <- merge(map_df, dat, by="id")

# find canton centers
centers <- data.frame(gCentroid(map, byid=TRUE))
centers$canton <- dat$canton

# make a map!
gg <- ggplot()
gg <- gg + geom_map(data=map_df, map=map_df,
                    aes(map_id=id, x=long, y=lat, group=group),
                    color="#ffffff", fill="#bbbbbb", size=0.25)
# gg <- gg + geom_point(data=centers, aes(x=x, y=y))
gg <- gg + geom_text(data=centers, aes(label=canton, x=x, y=y), size=3)
gg <- gg + coord_map()
gg <- gg + labs(x="", y="", title="Swiss Cantons")
gg <- gg + theme_map()
gg

ggsave("cantons.svg", gg, width=9, height=6)