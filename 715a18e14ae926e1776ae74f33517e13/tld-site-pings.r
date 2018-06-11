library(splashr) # you *need* to read https://github.com/hrbrmstr/splashr to run this script
library(urltools)
library(tidyverse)

splash_active() # if this does not return "TRUE" nothing will work

site <- render_har(url = "URL_TO_EVALUATE", response_body = TRUE)

map_chr(site$log$entries, c("response", "url")) %>% 
  urltools::domain() %>% 
  urltools::suffix_extract() %>% 
  mutate(tld = sprintf("%s.%s", domain, suffix)) %>% 
  count(tld, sort = TRUE)
