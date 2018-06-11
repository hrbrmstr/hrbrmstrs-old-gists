library(stringi)
library(purrr)

readLines("~/Dropbox/clamips.txt") %>% 
  stri_split_fixed(n=4, pattern=".") %>% 
  map(rev) %>% 
  map(paste0, collapse=".") %>% 
  unlist() %>% 
  sprintf("%s.in-addr.arpa", .) %>% 
  writeLines("~/Dropbox/clamarpa.txt")



