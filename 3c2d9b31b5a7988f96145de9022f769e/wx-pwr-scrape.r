library(httr)
library(magick)
library(rtweet)
library(stringi)
library(hrbrthemes)
library(tidyverse)

# NOTE: Needs bits from: https://gist.github.com/hrbrmstr/0ce866666f124c23e3b42ac7f16f3d3b

words_to_num <- function(x) {
  map_dbl(x, ~{
    val <- stri_match_first_regex(.x, "^([[:print:]]+) #PowerOutages")[,2]
    mul <- case_when(
      stri_detect_regex(val, "[Kk]") ~ 1000,
      stri_detect_regex(val, "[Mm]") ~ 1000000,
      TRUE ~ 1
    ) 
    val <- stri_replace_all_regex(val, "[^[:digit:]\\.]", "")
    as.numeric(val) * mul 
  })
}

outage <- get_timeline("PowerOutage_us", n=300)

filter(outage, stri_detect_regex(text, "\\#(EastCoast|NorthEast)")) %>% 
  mutate(created_at = lubridate::with_tz(created_at, 'America/New_York')) %>% 
  mutate(number_out = words_to_num(text)) %>%  
  ggplot(aes(created_at, number_out)) +
  geom_segment(aes(xend=created_at, yend=0), size=5) +
  scale_x_datetime(date_labels = "%Y-%m-%d\n%H:%M", date_breaks="2 hours") +
  scale_y_comma(limits=c(0,2000000)) +
  labs(
    x=NULL, y="# Customers Without Power",
    title="Northeast Power Outages",
    subtitle="Yay! Twitter as a non-blather data source",
    caption="Data via: @PowerOutage_us <https://twitter.com/PowerOutage_us>"
  ) -> gg

gg + theme_ipsum_rc(grid="Y", ticks = TRUE)  

gg_tweet(
  gg + theme_tweet_rc(grid="Y"),
  status = "Progress! #rtweet #gg_tweet",
  send=TRUE
)
