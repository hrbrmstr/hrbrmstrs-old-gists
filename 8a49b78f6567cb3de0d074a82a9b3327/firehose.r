library(httr)
library(tidyverse)

GET(
  url = "https://projects.propublica.org/electionbot/api/v1/firehose.json", 
  httr::add_headers(
    Accept = "application/json, text/javascript, */*; q=0.01", 
    `Accept-Language` = "en-US,en;q=0.5", 
    `Cache-Control` = "max-age=0", 
    Connection = "keep-alive", 
    DNT = "1", 
    Host = "projects.propublica.org", 
    `If-Modified-Since` = "Wed, 24 Jan 2018 02:48:12 GMT", 
    Referer = "https://projects.propublica.org/electionbot/", 
    `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:59.0) Gecko/20100101 Firefox/59.0", 
    `X-Requested-With` = "XMLHttpRequest"), 
  httr::set_cookies(
    `pp-tracking` = "{pageCount:0}", 
    `congress-tabs-cookie` = "{/:bills}")
) -> res

res <- jsonlite::fromJSON(content(res, as="text"))

tbl_df(res$firehose)
