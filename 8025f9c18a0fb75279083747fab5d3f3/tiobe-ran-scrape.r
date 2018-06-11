library(V8)
library(rvest)
library(hrbrthemes)
library(tidyverse)

ctx <- v8()

pg <- read_html("https://www.tiobe.com/tiobe-index/")

html_nodes(pg, xpath=".//script[contains(., 'series:')]") %>% 
  html_text() %>% 
  read_lines() -> index_js

index_js[which(grepl("series:", index_js)) + 1] %>% 
  sprintf("var dat = [ %s ];", .) %>% 
  ctx$eval()

x <- ctx$get("dat")

map(x$data, as.data.frame) %>% 
  map(set_names, c("date", "pct")) %>% 
  map(mutate, 
      date=as.POSIXct(date/1000, origin="1970-01-01 00:00:00", tz="UTC"),
      pct = pct / 100) %>% 
  set_names(x$name) %>% 
  bind_rows(, .id="lang") %>% 
  tbl_df() -> historical_tiobe

ggplot(historical_tiobe, aes(date, pct, group=lang)) +
  ggalt::stat_xspline(geom="area", aes(color=lang, fill=lang), alpha=2/3, size=1/4) +
  ggthemes::scale_color_tableau() +
  ggthemes::scale_fill_tableau() +
  scale_y_percent() +
  facet_wrap(~lang) +
  labs(
    x=NULL, y="TIOBE Index % rank", 
    title="Historical TIOBE Ratings", 
    caption="Source: <https://www.tiobe.com/tiobe-index/>"
  ) +
  theme_ipsum_ps(grid="XY") +
  theme(legend.position="none")

