library(darksky)
library(tidyverse)
library(ggbeeswarm)
library(hrbrthemes)

yrs <- 2000:2016
days <- 1:31

sprintf("%04d-07-", yrs) %>%
  map(~sprintf("%s%02dT20:00:00-0800", .x, days)) %>%
  flatten_chr() -> july_hist

pb <- progress_estimated(length(july_hist))
map(july_hist, ~{
  pb$tick()$print()
  get_forecast_for(36.1699, -115.1398, .x)
}) -> vegas_temps

vegas_temps

write_rds(vegas_temps, "~/Data/vegas_temps.rds")

vegas_temps <- read_rds("~/Data/vegas_temps.rds")

hourly_hist <- map_df(vegas_temps, "hourly")

hourly_hist$hr <- lubridate::hour(hourly_hist$time)

filter(hourly_hist, hr == 20) %>% 
  mutate(col=ifelse(temperature >= 100, "#b2182b", "#f6e8c3")) %>% 
  ggplot(aes(x="", temperature)) +
  geom_quasirandom(aes(fill=col), color="#2b2b2b", stroke=0.25, shape=21, size=3) +
  scale_y_continuous(breaks=c(80, 90, 100, 110), labels=sprintf("%d°F", c(80, 90, 100, 110))) +
  scale_fill_identity() +
  labs(x=NULL, y=NULL, 
       title="Historical Temperatures in July (1-31)\n2000-2016, 8pm (2000hrs)") +
  theme_ipsum_rc(grid="Y")
