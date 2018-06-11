library(rvest)
library(hrbrmisc)
library(stringi)
library(dplyr)
library(tidyr)
library(purrr)
library(V8)
library(lubridate)
library(seleniumPipes)

URL <- "https://www.netmarketshare.com/operating-system-market-share.aspx?qprid=9&qpcustomb=0&qpsp=192&qpnp=25&qptimeframe=M"

pg <- read_html(URL)

# rvest + v8 ------------------------------------------------------------------------

html_nodes(pg, xpath=".//script[contains(., 'plotOptions')]") %>%
  as.character() %>%
  stri_split_lines() %>%
  .[[1]] -> lines

lines <- c("var dat = {", lines[which(ggrepl(lines, "series: \\[")):(length(lines)-4)], "}")

ctx <- v8()
ctx$eval(lines)
ctx$get("dat.series") %>%
  unnest(data) %>%
  rename(os=name, share=data) %>%
  mutate(month=rep(seq((as.Date("2016-12-01") %m-% months(nrow(filter(., os=="Windows"))-1)),
                       by="1 month",
                       length.out=nrow(filter(., os=="Windows"))),
                   length(unique(.$os))),
         pct_lab=scales::percent(share)) -> monthly_os_market_share_rvest_v8

# selenium --------------------------------------------------------------------------

sp <- spectre()
sp %>% go(URL)

# selenium : way 1 ------------------------------------------------------------------

sp %>%
  findElement("css", "table#fwReportTable1") %>%
  getElementText() %>%
  stri_replace_all_fixed(", ", "_") %>%
  readr::read_delim(delim=" ") %>%
  setNames(stri_trans_tolower(colnames(.))) %>%
  mutate(month=as.Date(sprintf("%s 01", month), "%B_%Y %d")) %>%
  gather(os, pct_lab, -month) %>%
  mutate(share=make_percent(pct_lab))

# selenium : way 1 ------------------------------------------------------------------

sp %>%
  getPageSource() %>% 
  html_nodes("table#fwReportTable1") %>% 
  html_table() %>% 
  .[[1]] %>% 
  gather(os, pct_lab, -Month) %>% 
  mutate(Month=as.Date(sprintf("%s 01", Month), "%B, %Y %d"),
         share=make_percent(pct_lab))
