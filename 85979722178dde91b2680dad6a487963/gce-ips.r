library(resolv)
library(purrr)
library(stringi)

resolv_txt("_cloud-netblocks.googleusercontent.com", "ns1.google.com") %>% 
  stri_replace_all_regex("(^.*v=spf1 | \\?all.*$)", "") %>% 
  stri_replace_all_regex("include:", "") %>% 
  stri_split_regex(" ") %>% 
  flatten_chr() %>% 
  map(resolv_txt, "ns1.google.com") %>% 
  map(function(x) {
    x %>% 
      stri_replace_all_regex("(^.*v=spf1 | \\?all.*$)", "") %>% 
      stri_split_regex(" ")
  }) %>% 
  flatten() %>% 
  flatten_chr() %>% 
  keep(grepl, pattern="ip4") %>% 
  stri_replace_first_regex("ip4:", "")
