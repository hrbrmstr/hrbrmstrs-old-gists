library(rvest)
library(stringi)
library(tidyverse)

pg <- read_html("http://www.theacsi.org/customer-satisfaction-benchmarks/benchmarks-by-industry")

ind <- html_nodes(pg, "div[class='article_content'] * a[onclick]") 

data_frame(
  industry = html_text(ind),
  url = html_attr(ind, "onclick") %>% 
    stri_match_all_regex("'(http://www.*[[:alpha:]])','") %>% 
    at_depth(1, `[`, 2) %>% 
    flatten_chr()
) %>% 
  tail(-1) -> acsi_ind


pg <- read_html(acsi_ind$url[1])
html_table(pg, header = TRUE)[[1]] 