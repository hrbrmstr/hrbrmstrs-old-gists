library(httr)
library(dplyr)
library(readr)
library(stringr)
library(ggplot2)
library(ggthemes)
library(rgdal)
library(lubridate)

try(invisible(GET("ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/csv/Allstorms.ibtracs_wmo.v03r06.csv.gz",
                  write_disk("Allstorms.ibtracs_wmo.v03r06.csv.gz"))))

read_csv("Allstorms.ibtracs_wmo.v03r06.csv.gz", skip=1) %>%  # skip header
  tail(-1) %>%                                               # remove example line
  mutate_each(funs(str_trim)) %>%                            # remove leading/trailing whitespace
  type_convert("ciicccccddddcddc") %>%                       # convert column types
  mutate(ISO_time=as.POSIXct(ISO_time)) -> dat               # make it a real date (takes a few secs)

july_storms <- filter(dat, month(ISO_time)==7) %>% select(Serial_Num) %>% distinct

world_map <- map_data("world")

storms <- filter(dat, Serial_Num %in% july_storms$Serial_Num)

gg <- ggplot()
gg <- gg + geom_map(data=world_map, map=world_map,
                    aes(x=long, y=lat, map_id=region, group=group),
                    color="#dddddd", fill="#dddddd", size=0.25)
gg <- gg + geom_path(data=storms,
                     aes(x=Longitude, y=Latitude, group=Serial_Num,
                         color=`Wind(WMO) Percentile`),
                     alpha=1/5, size=0.5, shape=18)
gg <- gg + geom_point(data=storms,
                      aes(x=Longitude, y=Latitude),
                      size=0.5, alpha=1/2, color="#b30000")
gg <- gg + coord_map("orthographic", orientation=c(41, -74, 0))
gg <- gg + scale_color_distiller(palette="OrRd")
gg <- gg + labs(x=NULL, y=NULL, title="Historical July Tropical Storm/Typhoon Activity (1848-present)\n")
gg <- gg + theme_map()
gg <- gg + theme(legend.position="none")
gg
