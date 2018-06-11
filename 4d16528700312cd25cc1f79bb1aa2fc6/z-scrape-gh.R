library(git2r)
library(stringi)
library(httr)
library(rvest)
library(tidyverse)

GGET <- purrr::safely(httr::GET)

git2r::clone("git://github.com/rstudio/webinars.git", "/tmp/webinars") # takes a while

list.files("/tmp/webinars/", pattern="^[[:digit:]]") %>%
  stri_replace_first_regex("^[[:digit:]]+-", "") %>% 
  sprintf("https://www.rstudio.com/resources/webinars/%s", .) %>% 
  map(GGET) -> res
  
discard(res, ~is.null(.x$result)) %>% 
  discard(~status_code(.x$result) != 200) %>% 
  map_df(~{
    data_frame(
      src = content(.x$result, as="text"),
      doc = content(.x$result, as="parsed"),
      title = html_node(doc, "title") %>% html_text(),
      url = .x$result$url,
      md = sprintf("- [%s](%s)", title, url)
    )
  })

unlink("/tmp/webinars", recursive = TRUE)
