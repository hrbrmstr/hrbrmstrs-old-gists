#' ---
#' title: ""
#' author: ""
#' date: ""
#' output:
#'   html_document:
#'     keep_md: true
#'     theme: simplex
#'     highlight: monochrome
#' ---
#+ init, include=FALSE
knitr::opts_chunk$set(message = FALSE, warning = FALSE, dev="png",
                      fig.retina = 2, fig.width = 10, fig.height = 20)

#+ libs
library(newsflash)
library(hrbrthemes)
library(tidyverse)

#+ data
if (!file.exists("newsflash_top_trends.rds")) {
  
  pb <- progress_estimated(24)
  map(0:23, ~{
    pb$tick()$print()
    hr <- .x
    map(c(0, 15, 30, 45), ~top_trending(hour=hr, minute = .x))
  }) %>% flatten() -> res
  
  discard(res, ~is.null(.x)) %>% 
    map_df(~{
      .x$StationTrendingTopics$date <-  .x$DateGenerated
      tbl_df(.x$StationTrendingTopics)
    }) %>% 
    unnest(Topics) %>% 
    rename(station = Station, topic = Topics) %>% 
    count(date, topic) -> xdf
  
  rng <- range(xdf$date)
  rng <- seq(rng[1], rng[2], "15 mins")
  
  complete(xdf, date=rng, topic) -> xdf
  
  write_rds(xdf, "newsflash_top_trends.rds")
  
} else {
  
  xdf <- read_rds("newsflash_top_trends.rds")
  
}

#+ nf_top
ordr <- count(xdf, topic, wt=n, sort=TRUE) 

target <- grep("equifax", rev(ordr$topic))
tot <- nrow(ordr)

faces <- c(rep("plain", target-1), "bold", rep("plain", tot-target))
sizes <- c(rep(8, target-1), 18, rep(8, tot-target))

mutate(xdf, topic = factor(topic, levels=rev(ordr$topic))) %>% 
  ggplot(aes(date, topic, fill=n)) +
  geom_tile(color="#b2b2b2", size=0.125) +
  scale_x_datetime(expand=c(0,0)) +
  viridis::scale_fill_viridis(name="# TV Networks: ", na.value="white") +
  labs(x=NULL, y=NULL, title="Top Trending Today (GMT)", caption="Source: GDELT TV API & newsflash\nBlank columns indicate no data yet for that time.") +
  theme_ipsum_rc(grid="") +
  theme(axis.text.y=element_text(face=faces, size=sizes)) +
  theme(legend.position=c(0.7, 1.02), legend.direction = "horizontal")

