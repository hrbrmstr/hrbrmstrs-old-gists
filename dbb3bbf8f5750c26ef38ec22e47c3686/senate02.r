library(maptools)
library(ggplot2)
library(readr)
library(dplyr)
library(tidyr)
library(scales)

senate <- read_csv("~/Desktop/senate.csv")

us_map <- map_data("state")

state_trans <- tolower(state.name)
names(state_trans) <- state.abb

senate <- mutate(senate, region=state_trans[State])

gg <- ggplot()
gg <- gg + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=region),
                    color="#2b2b2b", size=0.15, fill=NA)
gg <- gg + geom_map(data=senate, map=us_map,
                    aes(fill=Score, map_id=region))
gg <- gg + coord_map()
gg <- gg + facet_wrap(~congress)
gg <- gg + theme_void()
gg
