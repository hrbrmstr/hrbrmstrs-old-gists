library(hrbrthemes)
library(tidyverse)

wkdy <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
names(wkdy) <- 0:6

hrs <- c(sprintf("%sa", c(12, 1:11)), sprintf("%sp", c(12, 1:11)))
names(hrs) <- 0:23

update_geom_font_defaults(font_rc)

jsonlite::fromJSON("pcd.json") %>% 
  tbl_df() %>% 
  set_names(c("day", "hour", "commits")) %>% 
  mutate(day = map_chr(day, ~wkdy[as.character(.)])) %>% 
  mutate(day = factor(day, levels=rev(wkdy))) %>% 
  mutate(hour = map_chr(hour, ~hrs[as.character(.)])) %>% 
  mutate(hour = factor(hour, levels=hrs)) %>% 
  mutate(commits = ifelse(commits==0, NA, commits)) %>% 
  mutate(color = ifelse(commits==5, "black", "white")) %>% 
  ggplot(aes(hour, day)) +
  geom_tile(aes(fill=commits), color="#b5b5b5", size=0.15) +
  geom_text(aes(label=commits, color=color)) +
  scale_color_identity() +
  viridis::scale_fill_viridis(na.value="white", guide=FALSE) +
  coord_equal() +
  labs(x=NULL, y=NULL) +
  theme_ipsum_rc()
