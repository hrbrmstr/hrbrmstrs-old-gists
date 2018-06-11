library(waffle)
library(viridis)
library(tidyverse)

data_frame(
  country = c("Rest of World", "Canada*", "Brazil*", "South Korea", "Mexico", 
              "Russia", "Turkey", "Japan", "Taiwan", "Germany", "India"),
  pct = c(22, 16, 13, 10, 9, 9, 7, 5, 4, 3, 2)
) %>% 
  mutate(country = sprintf("%s (%s%%)", country, pct)) %>% 
  waffle(
    colors = c("gray70", viridis_pal(option = "plasma")(10))
  ) +
  labs(
    title = "U.S. Steel Imports — YTD 2017 Percent of Volume",
    subtitle = "Ten nations account for ~80% of U.S. steel imports.",
    caption = "Source: IHS Global Trade Atlas • YTD through September 2017\n* Canada & Brazil are not impacted by the proposed tariffs"
  ) +
  theme_ipsum_ps() +
  theme(legend.position = "top") +
  theme(axis.text = element_blank()) +
  theme(title = element_text(hjust=0.5)) +
  theme(plot.title = element_text(hjust=0.5)) +
  theme(plot.subtitle = element_text(hjust=0.5)) +
  theme(plot.caption = element_text(hjust=1))