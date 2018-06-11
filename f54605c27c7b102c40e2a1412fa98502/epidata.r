library(epidata) # install.packages("epidata")
library(hrbrthemes) # install.packages("hrbrthemes")
library(tidyverse)

xdf <- get_median_and_mean_wages("l")

select(xdf, -median, -average) %>% 
  gather(measure, value, -date) %>% 
  mutate(measure = str_replace_all(measure, "_", " ")) %>% 
  mutate(measure = str_to_title(measure)) %>% 
  mutate(date = as.Date(sprintf("%s-01-01", date))) %>% 
  ggplot(aes(date, value)) +
  ggalt::stat_xspline(geom="area", fill="lightslategray", color="lightslategray", size=3/4, alpha=2/3) +
  scale_y_continuous(expand=c(0,0), labels=scales::dollar, limits=c(0,20)) +
  facet_wrap(~measure, scales="free_y") +
  labs(
    x=NULL, y="Hourly wage (USD)",
    title="Hourly wage, entry-level positions (college/high school graduate)",
    subtitle="Adjusted for inflation (values in 2016 dollars)",
    caption='Citation: "Economic Policy Institute"'
  ) +
  theme_ipsum_rc(grid="XY")
