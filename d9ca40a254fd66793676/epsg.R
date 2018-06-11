gg <- ggplot()
gg <- gg + geom_map(data=state, map=state,
                    aes(x=long, y=lat, map_id=region))
gg <- gg + coord_proj("+init=epsg:4617")
gg <- gg + theme_map()
gg
