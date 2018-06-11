library(V8)
library(xml2)
library(httr)
library(rvest)
library(stringi)
library(tidyverse)

get_page <- function(num=1, seed=Sys.Date()) {
  
  GET(
    url = "https://www.pexels.com/search/nature/",
    query = list(
      page=num,
      format="js",
      seed=seed
    )
  ) -> res
  
  stop_for_status(res)
  
  x <- content(res)
  x <- stri_replace_first_regex(x, "^.*beforeend','\\\\n\\\\n", "'")
  x <- stri_replace_last_regex(x, "\\\\n\\\\n'\\);rowG.*$", "'")
  
  ctx <- v8()
  
  pg <- read_html(ctx$eval(x))
  
  data_frame(
    preview_href = html_attr(html_nodes(pg, "img"), "src"),
    full_href = sprintf("https://www.pexels.com%s", html_attr(html_nodes(pg, "a"), "href")),
    title = html_attr(html_nodes(pg, "a"), "title")
  )
  
} 
