library(hrbrthemes)
library(ggalt)
library(viridis)
library(tidyverse)

axios <- read_csv("Axios Trump News Cycle 12_21 - Events (indexed separately by event).csv")

gather(axios, event, value, -Day) %>% 
  mutate(Day = as.Date(Day, "%b %e %Y")) %>%
  mutate(event = factor(event, levels=unique(event))) %>% 
  group_by(event) %>% 
  mutate(fill = mean(value)) %>% 
  ungroup() -> axios

ggplot(axios, aes(Day, value, group=event)) +
  ggalt::stat_xspline(geom="area", aes(fill=fill, color=fill), size=0.5, alpha=1/3, spline_shape = 0.5) +
  scale_x_date(expand=c(0,0), date_breaks="1 month", date_labels = "%b") +
  scale_y_continuous(expand=c(0,0)) +
  viridis::scale_color_viridis(direction=-1) +
  viridis::scale_fill_viridis(direction=-1) +
  facet_wrap(~event, ncol=1, strip.position = "left") +
  labs(x=NULL, y=NULL) +
  theme_ipsum_rc(grid="X", strip_text_size = 16) +
  theme(panel.grid.major.x = element_line(size=0.125, color="#c3c3c3")) +
  theme(panel.spacing.y=unit(0, "null")) +
  theme(panel.spacing.y=unit(-20, "pt")) +
  theme(axis.text.y=element_blank()) +
  theme(strip.text.y = element_text(hjust=1, vjust=0, angle=360, family = font_rc_light)) +
  theme(legend.position="none") -> gg

ggsave(
  file = "potus-ridgeline.png",
  plot = gg,
  width = 25,
  height = 36,
  dpi = "retina"
)
