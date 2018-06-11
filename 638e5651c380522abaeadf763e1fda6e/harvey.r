library(ggalt)
library(rrricanes)

storms <- get_storms(year=2017L, basin="AL")

us_aeqd_proj <- "+proj=aeqd +lat_0=40.08355112574181 +lon_0=-95.44921875"

filter(storms, grepl("Harvey", Name))$Link %>%
  get_storm_data() -> harvey

gis_advisory(harvey$fstadv$Key[1]) %>% 
  last() %>% 
  gis_download() -> harvey_gis

harvey_path <- shp_to_df(harvey_gis[[grep("5day_lin", names(harvey_gis), value=TRUE)]])

us <- map_data("state")

ggplot() +
  geom_cartogram(data=us, map=us, aes(map_id=region), 
                 color="#2b2b2b", fill="#b2b2b2", size=0.25) +
  geom_path(data = harvey_path, aes(long, lat, group = FCSTPRD), size=1) +
  geom_point(data = harvey_path, aes(long, lat, group = FCSTPRD, color = STORMTYPE), size=5) +
  geom_text(data = harvey_path, aes(long, lat, label=order, group = FCSTPRD), size=4.5) +
  scale_x_continuous(limits=range(-107, -90)) +
  scale_y_continuous(limits=range(22.5, 36)) +
  coord_proj(us_aeqd_proj) +
  ggthemes::theme_map()


