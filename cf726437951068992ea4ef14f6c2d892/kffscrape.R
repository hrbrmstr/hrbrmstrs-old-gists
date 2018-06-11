library(rvest)
library(stringi)
library(jsonlite)
library(tidyverse)

ctx <- v8()

pg <- read_html("https://www.kff.org/other/state-indicator/market-share-and-enrollment-of-largest-three-insurers-large-group-market/?currentTimeframe=0&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D")

html_node(pg, xpath=".//script[contains(., 'Premera')]") %>% 
  html_text() %>% 
  stri_split_lines() %>% 
  flatten_chr() %>% 
  keep(stri_detect_fixed, "jQuery") %>% 
  stri_replace_first_regex("^.*\\{", "{") %>% 
  stri_replace_last_regex("\\);", "") %>% 
  jsonlite::fromJSON(js) -> ins_dat
