library(rgeos)
library(rgdal)
library(httr)
library(dplyr)

geo_init <- function() {

  try({
    GET("http://www.mapcruzin.com/fcc-wireless-shapefiles/cities-towns.zip",
        write_disk("cities.zip"))
    unzip("cities.zip", exdir="cities") })

  shp <- readOGR("cities/citiesx020.shp", "citiesx020")

  geo <-
    gCentroid(shp, byid=TRUE) %>%
    data.frame() %>%
    rename(lon=x, lat=y) %>%
    mutate(city=shp@data$NAME, state=shp@data$STATE)

}

geocode <- function(geo_db, city, state) {
  do.call(rbind.data.frame, mapply(function(x, y) {
    geo_db %>% filter(city==x, state==y)
  }, city, state, SIMPLIFY=FALSE))
}


geo_db <- geo_init()

geo_db %>% geocode("Portland", "ME")

geo_db %>%
  geocode(c("Portland", "Berwick", "Alfred"), "ME")

geo_db %>%
  geocode(city=c("Baltimore", "Pittsburgh", "Houston"),
          state=c("MD", "PA", "TX"))