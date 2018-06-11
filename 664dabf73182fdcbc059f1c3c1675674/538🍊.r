library(V8)
library(httr)
library(stringi)
library(tidyverse)

# lots of sites are going to have cert errors this year if they don't 
# change providers, so you've got to do this if your OS updates
# the cert-db. it's generally not a good thing to do.

res <- GET("https://projects.fivethirtyeight.com/congress-trump-score/", 
           config = httr::config(ssl_verifypeer = FALSE))

# content is in a javascript object that is (thankfully) all on one
# line but said line also has some cruft we need to remove.

content(res, as = "text") %>%
  stri_split_lines() %>% 
  unlist() %>% 
  grep("var memberScores", ., value = TRUE) %>% 
  stri_replace_last_regex("</script>.*$", ";") -> jsdat

# not stick it into the javascript machine

ctx <- v8()
ctx$eval(JS(jsdat))

# and pull it back out

ctx$get("memberScores", flatten = TRUE) %>% 
  map(as_tibble) -> member_scores
