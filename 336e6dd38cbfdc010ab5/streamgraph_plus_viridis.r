library(dplyr)
library(streamgraph)
library(viridis)

ggplot2::movies %>%
select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  tally(wt=value) %>%
  ungroup %>%
  mutate(year=as.Date(sprintf("%d-01-01", year))) -> dat

streamgraph(dat, "genre", "n", "year") %>% 
  sg_axis_x(tick_interval=10, tick_units="years", tick_format="%Y") %>% 
  sg_fill_manual(values=viridis(10, option="D"))