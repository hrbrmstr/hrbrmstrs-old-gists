  library(rgeos)
  library(rgdal) # needs gdal > 1.11.0
  library(ggplot2)
  
  # map theme
  devtools::source_gist("https://gist.github.com/hrbrmstr/33baa3a79c5cfef0f6df")
  
  # grab each of the layers
  
  limites = readOGR("division.json", "limites")
  provincias = readOGR("division.json", "provincias")
  cantones = readOGR("division.json", "cantones")
  distritos = readOGR("division.json", "distritos")

  # make the data frame
  
  limites_df <- fortify(limites)
  cantones_df <- fortify(cantones)
  distritos_df <- fortify(distritos)
  provincias_df <- fortify(provincias)
  
  # make a map! style it like the D3 example
  
  gg <- ggplot()
  gg <- gg + geom_map(data=limites_df, map=limites_df,
                      aes(map_id=id, x=long, y=lat, group=group),
                      color="white", fill="#dddddd", size=0.25)
  gg <- gg + geom_map(data=cantones_df, map=cantones_df,
                      aes(map_id=id, x=long, y=lat, group=group),
                      color="red", fill="#ffffff00", size=0.2)
  gg <- gg + geom_map(data=distritos_df, map=distritos_df,
                      aes(map_id=id, x=long, y=lat, group=group),
                      color="#999999", fill="#ffffff00", size=0.1)
  gg <- gg + geom_map(data=provincias_df, map=provincias_df,
                      aes(map_id=id, x=long, y=lat, group=group),
                      color="black", fill="#ffffff00", size=0.33)
  gg <- gg + coord_map()
  gg <- gg + labs(x="", y="", title="Costa Rica TopoJSON")
  gg <- gg + theme_map()
  gg
  
  ggsave("costarica.svg", gg, width=11, height=9)
