library(rvest)
library(dplyr)
library(stringr)
library(tidyr)
library(maps)
library(ggplot2)
library(ggthemes)
library(grid)
library(leaflet)
library(sp)
library(viridis)

URL <- "http://www.tropicalatlantic.com/modelsystem/data.cgi?basin=al&year=2015&storm=11&display=modeltext&latestrun=1"

pg <- read_html(URL)

tab <- tbl_df(html_table(html_nodes(pg, "table")[[1]]))

pasta <- mutate_each(tab, funs(str_replace(., "[[:digit:]]+ knot.*$", "")), -`Model Name`)
pasta <- filter(pasta, `Model Name` != "Model Name")
pasta <- pasta[pasta[,2] != "",]
pasta <- gather(pasta, timestamp, position, -`Model Name`)
pasta <- mutate(pasta, timestamp=as.character(timestamp))
pasta <- separate(pasta, position, c("lat", "lon"), " ", fill="right")
pasta <- filter(pasta, !is.na(lon))

to_dec <- function(pos) {
  num <- as.numeric(str_replace(pos, "[[:alpha:]]", ""))
  ifelse(grepl("[SW]$", pos), -num, num)
}

pasta <- mutate_each(pasta, funs(to_dec), lat, lon)

world <- map("world", xlim=range(pasta$lon), ylim=range(pasta$lat), fill=TRUE, plot=FALSE)
world <- fortify(world)
us <- map_data("state")

fl <- unique(pasta$timestamp)
fl <- c(fl[1], fl[length(fl)])

ggplot() +
  geom_map(data=world, map=world, aes(x=long, y=lat, map_id=region), size=0.15, color="#7f7f7f", fill="white") +
  geom_map(data=us, map=us, aes(x=long, y=lat, map_id=region), size=0.15, color="#7f7f7f", fill="white") +
  geom_path(data=pasta, aes(x=lon, y=lat, group=`Model Name`, color=`Model Name`), size=0.5, alpha=0.5) +
  geom_point(dat=pasta, aes(x=lon, y=lat, group=`Model Name`, color=`Model Name`), size=1.25, alpha=0.5) +
  coord_map("albers", lat0=39, lat1=45) +
  xlim(range(pasta$lon)) +
  ylim(range(pasta$lat)) +
  theme_map() +
  labs(title=paste("Hurricane Joaquin\n", paste(fl, collapse=" to "))) +
  theme(legend.position="none") +
  theme(axis.title.x=element_text()) +
  theme(panel.background=element_rect(fill="#c1e4ff", color="#7f7f7f"))

pleaf <- data.frame(rename(pasta, 
                           model=`Model Name`,
                           long=lon), stringsAsFactors=FALSE)

sldf <- points_to_line(pleaf, "long", "lat", "model")

leaflet(sldf) %>% addTiles() %>% addPolylines(weight=1, color=gsub("FF$", "", viridis(length(unique(pleaf$model)))))
