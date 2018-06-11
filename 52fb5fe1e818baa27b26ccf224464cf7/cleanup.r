library(V8)
library(tidyverse)

ctx <- v8()

readBin("nuclear.js", "raw", file.size("nuclear.js")) %>% 
  rawToChar() %>% 
  sprintf("var data = { %s }", .) %>% 
  ctx$eval()

ctx$get("data", flatten=TRUE)$nuclear$geometries %>% 
  select(-type) %>% 
  tbl_df() %>% 
  mutate(
    x = as.numeric(map_chr(coordinates, ~.x[[1]])),
    y = as.numeric(map_chr(coordinates, ~.x[[2]]))
  ) %>% 
  select(-coordinates) %>% 
  set_names(gsub("^properties\\.", "", colnames(.))) %>% 
  mutate(date = lubridate::ymd(sprintf("%s-%s-%02d", year, tolower(month), as.integer(day)))) %>% 
  mutate(yield = as.numeric(yield)) %>% 
  mutate(name = gsub("\ +", " ", name)) %>% 
  select(date, country, year, yield, type, name, x, y) -> xdf

glimpse(xdf)
## Observations: 2,056
## Variables: 8
## $ date    <date> 1945-07-16, 1946-06-30, 1946-07-24, 1948-04-14, 1948-04-30, 1948...
## $ country <chr> "US", "US", "US", "US", "US", "US", "US", "US", "US", "US", "US",...
## $ year    <chr> "1945", "1946", "1946", "1948", "1948", "1948", "1951", "1951", "...
## $ yield   <dbl> 21.00, 21.00, 21.00, 37.00, 49.00, 18.00, 1.00, 8.00, 1.00, 8.00,...
## $ type    <chr> "A", "A", "U", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", ...
## $ name    <chr> "TrinityTrinity", "CrossroadsAble", "CrossroadsBaker", "Sandstone...
## $ x       <dbl> 2043, 9596, 9596, 9506, 9508, 9509, 1779, 1779, 1779, 1779, 1779,...
## $ y       <dbl> 7047, 5741, 5742, 5747, 5744, 5741, 7232, 7232, 7232, 7232, 7232,...