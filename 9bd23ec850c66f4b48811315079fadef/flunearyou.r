library(httr)
library(dplyr)
library(jsonlite)

res <- httr::GET("https://api.v2.flunearyou.org/map/markers", 
                 httr::add_headers(Origin = "https://flunearyou.org", 
                                   `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36", 
                                   Referer = "https://flunearyou.org/"))

httr::content(res, as="text", encoding="UTF-8") %>% 
  jsonlite::fromJSON(flatten=TRUE) %>% 
  dplyr::tbl_df()


