library(rvest)
library(xml2)
library(stringi)
library(tidyverse)

pg <- read_html("https://nvd.nist.gov/vuln/data-feeds#CVE_FEED")

html_nodes(pg, "tr.xml-feed-data-row td.xml-file-type a") %>% 
  html_attr("href") %>% 
  keep(stri_detect_fixed, "eeds/json/cve/1.0/nvdcve") %>% 
  discard(stri_detect_regex, "zip|modified|recent") %>% 
  walk(~download.file(.x, file.path("~/Data/nvd", basename(.x))))

list.files("~/Data/nvd", "json.gz$", full.names=TRUE)

cv <- jsonlite::fromJSON("/Users/bob/Data/nvd/nvdcve-1.0-2017.json.gz")

bind_cols(
  id = cv$CVE_Items$cve$CVE_data_meta$ID,
  descr = map_chr(cv$CVE_Items$cve$description$description_data, ~.x$value[1])  
) %>% 
  filter(grepl("remote", descr, ignore.case=TRUE))
  
# AND/OR filter(grepl("code ex", descr, ignore.case=TRUE))

