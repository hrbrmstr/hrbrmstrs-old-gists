library(tidyverse)

ufos <- read_csv("~/Data/scrubbed.csv")

filter(ufos, country=="us" & (!(state %in% c("ak", "hi", "pr")))) %>%
  ggplot(aes(longitude, latitude)) +
  geom_jitter(alpha=1/20, size=0.15, color="#ffeda0") +
  coord_map("albers", lat0=30, lat1=40) +
  ggthemes::theme_map() +
  theme(panel.background=element_rect(fill="#2b2b2b"))
