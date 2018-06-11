---
title: "Airport Wi-Fi"
author: ""
date: "`r sprintf('Last run: %s', format(Sys.time(), '%d %B, %Y'))`"
output: 
  html_document:
    code_download: true
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, message=FALSE)
```

```{r libs}
library(xml2)
library(stringi)
library(htmltools)
library(leaflet)
library(DT)
library(tidyverse)
```

```{r get_data}
airports_pass_kml <- "https://www.google.com/maps/d/u/0/kml?mid=1Z1dI8hoBZSJNWFx2xr_MMxSxSxY&lid=zSq6Oj3AR-pc.krVRyoyuD_mY&forcekml=1"

read_xml(airports_pass_kml) %>% xml_ns_strip() -> pass
```

```{r process_data}
xml_extract_all <- function(doc, xpath) {
  xml_find_all(doc, xpath) %>% xml_text()
}

leaflet_description <- function(x) {
  x %>% 
    stri_replace_all_regex("(;| -|- | -- |, )", "<br/>") %>% 
    stri_replace_all_regex("\\.", ".<br/>") %>% 
    stri_replace_all_regex("Delta Sky Club", "Delta Sky Club<br/>") %>% 
    stri_replace_all_regex("British Airways Lounge", "British Airways Lounge<br/>") %>% 
    stri_replace_all_regex("American Airlines Lounge", "American Airlines Lounge<br/>") %>% 
    stri_replace_all_regex("[Nn]etwork:", "<b>Network</b>:") %>% 
    stri_replace_all_regex("[Uu]sername:", "<b>Username</b>:") %>% 
    stri_replace_all_regex("([Pp]assword|Pass):", "<b>Password</b>:") %>% 
    stri_replace_all_regex("[Nn]etwork [Nn]ame[:]", "<b>Network name</b>:")
}

data_frame(
  name = xml_extract_all(pass, ".//Placemark/name"),
  description = xml_extract_all(pass, ".//Placemark/description"),
  coords = xml_extract_all(pass, ".//Placemark/Point/coordinates")
) %>%
  separate(coords, c("lng", "lat", "z"), sep=",") %>% 
  mutate(
    lng = as.numeric(lng), 
    lat = as.numeric(lat),
    dt = leaflet_description(description),
    popup = sprintf("<h3 style='border-bottom:1px solid black'>%s</h3>%s", name, dt)
  ) %>% 
  select(-z) -> pass_df
```

```{r leaflet}
leaflet(pass_df, width="100%") %>% 
  addTiles() %>% 
  addMarkers(popup = ~popup)
```

### Searchable Airport Wi-Fi Database

```{r dt}
DT::datatable(select(pass_df, Airport=name, `Wi-Fi Info`=dt), escape=FALSE)
```
