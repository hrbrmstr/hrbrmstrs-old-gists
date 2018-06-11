library(tigris)
library(ggplot2)
library(ggthemes)
library(rgeos)

me <- counties("23")

me_simp <- gSimplify(me, tol=1/200, topologyPreserve=TRUE)

me_map <- fortify(me_simp)

gg <- ggplot()
gg <- gg + geom_map(data=me_map, map=me_map,
                    aes(x=long, y=lat, map_id=id),
                    color="black", fill="white", size=0.25)
gg <- gg + coord_map()
gg <- gg + theme_map()
gg
