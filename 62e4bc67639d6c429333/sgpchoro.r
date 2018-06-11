library(rgeos)
library(maptools)
library(ggplot2)

sg <- raster::getData(country="SGP", level=1)

sg_map <- ggplot2::fortify(sg, region="NAME_1")

choro_dat <- cbind.data.frame(
  data.frame(region=sg@data$NAME_1,
             value=sample(100, nrow(sg@data)),
             stringsAsFactors=FALSE),
  data.frame(rgeos::gCentroid(sg, byid=TRUE))
)

gg <- ggplot()
gg <- gg + geom_map(data=sg_map, map=sg_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#b2b2b200", fill="#ffffff00", size=0.15)
gg <- gg + geom_map(data=choro_dat, map=sg_map,
                    aes(fill=value, map_id=region),
                    color="#b2b2b2", size=0.15)
gg <- gg + ggrepel::geom_label_repel(data=choro_dat, aes(x=x, y=y, label=region))
gg <- gg + ggalt::coord_proj("+proj=aea +lon_0=103.8474")
gg <- gg + viridis::scale_fill_viridis(name="Measure")
gg <- gg + ggthemes::theme_map()
gg <- gg + theme(legend.position="bottom")
gg

