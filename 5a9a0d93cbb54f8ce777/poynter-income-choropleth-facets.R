library(rgdal)
library(dplyr)
library(readr)
library(stringi)
library(stringr)
library(tidyr)
library(grid)
library(scales)
library(ggplot2)
library(ggthemes)
library(httr)

# poynter's map is from: http://www.pewglobal.org/wp-content/lib/js/world-geo.json
try(invisible(GET("http://www.pewglobal.org/wp-content/lib/js/world-geo.json",
                  write_disk("world-geo.json"))), silent=TRUE)

# read in map and re-project it and make it usable for ggplot
# poynter uses the robinson projection, so we shall as well
world <- readOGR("world-geo.json", "OGRGeoJSON")
world_wt <- spTransform(world, CRS("+proj=robin"))
world_map <- fortify(world_wt)

# if you try to use "region='name'" in that "foritfy" you'll get a
# TopologyException, and the normal "gBuffer" solution won't fix it
# properly, but we can "fix" this manually since I really want to
# use the name for the country fills

world_map %>%
  left_join(data_frame(id=rownames(world@data), name=world@data$name)) %>%
  select(-id) %>%
  rename(id=name) -> world_map

# get pop data
# http://www.pewglobal.org/wp-content/themes/pew-global/interactive-global-class.csv
read_csv("http://www.pewglobal.org/wp-content/themes/pew-global/interactive-global-class.csv") %>%
  mutate_each(funs(str_trim)) %>%
  filter(id != "None") %>%
  mutate_each(funs(as.numeric(.)/100), -name, -id) -> dat

# only going to work with the share % for now
dat %>%
  gather(share, value, starts_with("Share"), -name, -id) %>%
  select(-starts_with("Change")) %>%
  mutate(label=factor(stri_trans_totitle(str_match(share, "Share ([[:alpha:]- ]+),")[,2]),
                      c("Poor", "Low Income", "Middle Income", "Upper-Middle Income", "High Income"),
                      ordered=TRUE)) -> share_dat

# use same "cuts" as poynter
poynter_scale_breaks <- c(0, 2.5, 5, 10, 25, 50, 75, 80, 100)

# make nicer labels for the legend and use poynter's legend breaks
sprintf("%2.1f-%s", poynter_scale_breaks, percent(lead(poynter_scale_breaks/100))) %>%
  stri_replace_all_regex(c("^0.0", "-NA%"), c("0", "%"), vectorize_all=FALSE) %>%
  head(-1) -> breaks_labels

share_dat %>%
  mutate(`Share %`=cut(value,
                       c(0, 2.5, 5, 10, 25, 50, 75, 80, 100)/100,
                       breaks_labels))-> share_dat

# use poynter's palette
share_pal <- c("#eaecd8", "#d6dab3", "#c2c98b", "#949D48", "#6e7537", "#494E24", "#BB792A", "#7C441C", "#ffffff")

# build the plot
gg <- ggplot()

# base map
gg <- gg + geom_map(data=world_map, map=world_map,
                    aes(x=long, y=lat, group=group, map_id=id),
                    color="#7f7f7f", fill="white", size=0.15)

# choropleth
gg <- gg + geom_map(data=share_dat, map=world_map,
                    aes(map_id=name, fill=`Share %`),
                    color="#7f7f7f", size=0.15)

gg <- gg + scale_fill_manual(values=share_pal)

# turn off the slashes in the legend boxes
gg <- gg + guides(fill=guide_legend(override.aes=list(colour=NA)))
gg <- gg + labs(title="World Population by Income\n")
gg <- gg + facet_wrap(~label, ncol=2)

# we've already projected it, so coord_equal is correct
gg <- gg + coord_equal()

# from ggthemes
gg <- gg + theme_map()

# making things prettier
gg <- gg + theme(panel.margin=unit(1, "lines"))
gg <- gg + theme(plot.title=element_text(face="bold", hjust=0, size=24))
gg <- gg + theme(legend.title=element_text(face="bold", hjust=0, size=12))
gg <- gg + theme(legend.text=element_text(size=10))
gg <- gg + theme(strip.text=element_text(face="bold", size=10))
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(legend.position="bottom")

# see the results
gg