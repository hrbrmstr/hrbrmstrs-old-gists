library(rgdal)
library(magrittr)

# save this locally for realz

world <- readOGR("https://raw.githubusercontent.com/AshKyd/geojson-regions/master/data/source/ne_50m_admin_0_countries.geo.json", "OGRGeoJSON")

# assumes 'places' is a data.frame with at least lat/lon columns

places %>%
  select(lon, lat) %>%
  coordinates %>%
  SpatialPoints(CRS(proj4string(world))) %over% world %>%
  select(iso_a2, name) %>%
  cbind(places, .)

# grab gadm2 - http://www.gadm.org/version2 (330M!)

# this takes _forever_
big_world <- readOGR("gadm2.shp", "gadm2")

# this part takes a while, too, so best save off temp results
big_res <- places %>%
  select(lon, lat) %>%
  coordinates %>%
  SpatialPoints(CRS(proj4string(big_world))) %over% big_world

big_res %>%
  select(iso_a2=ISO, name=NAME_0, name_1=NAME_1, name_2=NAME_2) %>%
  cbind(places, .)
