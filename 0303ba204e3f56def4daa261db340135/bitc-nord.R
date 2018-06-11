#' ---
#' title: "Bitcoin World Map Bubbles"
#' author: ""
#' date: ""
#' output:
#'   html_document:
#'     keep_md: false
#'     theme: simplex
#'     highlight: monochrome
#' ---
#+ init, include=FALSE
knitr::opts_chunk$set(message = FALSE, warning = FALSE, dev="png",
                      fig.retina = 2, fig.width = 10, fig.height = 6)

#+ libs
library(swatches)
library(ggalt) # devtools::install_github("hrbrmstr/ggalt")
library(hrbrthemes) # devtools::install_github("hrbrmstr/hrbrthemes")
library(tidyverse)

#' Read in the palette, Bitcoin node data and the world minus the penguins

#+ data
nord <- read_palette("nord.ase")

read_csv("bitc.csv") %>%
  count(lng, lat, sort = TRUE) -> bubbles_df

world <- map_data("world")
world <- world[world$region != "Antarctica", ]

#' Take a look at the palette

#+ palette, fig.height=3.5
show_palette(nord)

#' Now, make the map

#+ map, fig.height=8
ggplot() +
  geom_cartogram(
    data = world, map = world,
    aes(x = long, y = lat, map_id = region),
    color = nord["nord3"], fill = nord["nord0"], size = 0.125
  ) +
  geom_point(
    data = bubbles_df, aes(lng, lat, size = n), fill = nord["nord13"],
    shape = 21, alpha = 2/3, stroke = 0.25, color = "#2b2b2b"
  ) +
  coord_proj("+proj=wintri") +
  scale_size_area(name = "Node count", max_size = 20, labels = scales::comma) +
  labs(
    x = NULL, y = NULL,
    title = "Bitcoin Network Geographic Distribution (all node types)",
    subtitle = "(Using bubbles seemed appropriate for some, odd reason)",
    caption = "Source: Rapid7 Project Sonar"
  ) +
  theme_ipsum_tw(plot_title_size = 24, subtitle_size = 12) +
  theme(plot.title = element_text(color = nord["nord14"], hjust = 0.5)) +
  theme(plot.subtitle = element_text(color = nord["nord14"], hjust = 0.5)) +
  theme(panel.grid = element_blank()) +
  theme(plot.background = element_rect(fill = nord["nord3"], color = nord["nord3"])) +
  theme(panel.background = element_rect(fill = nord["nord3"], color = nord["nord3"])) +
  theme(legend.position = c(0.5, 0.05)) +
  theme(axis.text = element_blank()) +
  theme(legend.title = element_text(color = "white")) +
  theme(legend.text = element_text(color = "white")) +
  theme(legend.key = element_rect(fill = nord["nord3"], color = nord["nord3"])) +
  theme(legend.background = element_rect(fill = nord["nord3"], color = nord["nord3"])) +
  theme(legend.direction = "horizontal")
