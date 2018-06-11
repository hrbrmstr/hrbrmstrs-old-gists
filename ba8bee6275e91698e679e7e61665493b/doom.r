library(ggplot2)
library(rvest)
library(stringr)
library(ggthemes)
library(ggalt)

URL <- "http://www.somerikko.net/impacts/database.php"
pg <- read_html(URL)
tab <- html_table(html_nodes(pg, "table")[[2]], fill=TRUE)
tab <- tab[,1:6]
tab <- tab[4:235,]
tab <- setNames(tab, c("structure", "country", "lat", 
                       "long", "diam_km", "age_ma_or_date"))
tab <- tab[complete.cases(tab),]

degreeize <- function(x) {
  x <- as.numeric(x)
  x[1] + x[2]/60
}

lat <- gsub(" ", "", sub("['\\.].*$", "", tab$lat))
lat <- sub("^N", "", lat)
lat <- sub("^S", "-", lat)
tab$lat <- sapply(str_split(lat, "°"), degreeize)

lon <- gsub(" ", "", sub("['\\.].*$", "", tab$long))
lon <- sub("^E", "", lon)
lon <- sub("^W", "-", lon)
tab$long <- sapply(str_split(lon, "°"), degreeize)

world_map <- map_data("world")
# intercourse antarctica
world_map <- subset(world_map, region != "Antarctica")

gg <- ggplot()
gg <- gg + geom_map(data=world_map, map=world_map,
                    aes(x=long, y=lat, map_id=region),
                    color="white", size=0.15, 
                    fill="#b2b2b2")
gg <- gg + geom_point(data=tab, aes(x=long, y=lat), color="#b2182b")
gg <- gg + coord_proj()
gg <- gg + theme_map()
gg

