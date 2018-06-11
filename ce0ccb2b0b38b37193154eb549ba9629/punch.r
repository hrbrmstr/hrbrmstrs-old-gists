library(httr)
library(rvest)
library(jsonlite)
library(tidyverse)

punch_it <- function(dom) {
  
  POST(url = "https://domainpunch.com/tlds/search.php", 
       query = list(w=dom),
       add_headers(
         Origin = "https://domainpunch.com", 
         `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.29 Safari/537.36", 
         Referer = "https://domainpunch.com/tlds/search.php", 
         `X-Requested-With` = "XMLHttpRequest")) -> res
       
  stop_for_status(res)
  
  res <- content(res, as="text", encoding="UTF-8")
  res <- jsonlite::fromJSON(res, flatten=FALSE)
  
  if (length(res$table)>0) {
     ret <- read_html(res$table) %>% html_table() %>%  .[[1]]
     as_tibble(ret[-1,-1])
  } else {
    NULL
  }
  
}

punch_it("rapid7")
## # A tibble: 22 × 4
##              Domain  Zone Length  Info
## *             <chr> <chr>  <chr> <chr>
## 1        rapid7.com   com      6  info
## 2        rapid7.net   net      6  info
## 3        rapid7.org   org      6  info
## 4        rapid7.biz   biz      6  info
## 5       rapid7.info  info      6  info
## 6       rapid7.help  help      6  info
## 7      rapid7.cloud cloud      6  info
## 8      rapid7.sucks sucks      6  info
## 9  rapid7-china.com   com     12  info
## 10    rapid7-cn.com   com      9  info
## # ... with 12 more rows