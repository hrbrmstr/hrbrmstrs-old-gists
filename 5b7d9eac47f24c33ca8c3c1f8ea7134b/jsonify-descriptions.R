library(stringi)
library(tidyverse)

list.files(
  path = "/cran/web/packages", 
  pattern = "DESCRIPTION", 
  recursive = TRUE, 
  full.names = TRUE
) -> fils

s_read_dcf <- safely(read.dcf)

map(fils, s_read_dcf) %>% 
  discard(~is.null(.x$result)) %>% 
  map_df(~as_data_frame(.x$result)) %>% 
  janitor::clean_names() %>% 
  mutate(authors_r = map2(authors_r, encoding, ~{
    if (!is.na(.y)) {
      res <- try(unclass(eval(parse(text=.x, encoding = .y))))
    } else {
      res <- try(unclass(eval(parse(text=.x))))
    }
    if (inherits(res, "try-error")) "MALFORMED [aut, cre]" else res
  })) %>% 
  mutate(depends = stri_split_regex(depends, ",[[:space:]]*")) %>% 
  mutate(imports = stri_split_regex(imports, ",[[:space:]]*")) %>% 
  mutate(remote_repos = stri_split_regex(remote_repos, ",[[:space:]]*")) %>% 
  mutate(remotes = stri_split_regex(remotes, ",[[:space:]]*")) %>% 
  mutate(linking_to = stri_split_regex(linking_to, ",[[:space:]]*")) %>% 
  mutate(bug_reports = stri_split_regex(bug_reports, ",[[:space:]]*")) %>% 
  mutate(packaged = anytime::anytime(packaged)) %>% 
  mutate(date_publication = anytime::anytime(date_publication)) %>% 
  mutate(collate = stri_split_lines(collate)) %>% 
  mutate(author = stri_split_lines(author)) %>% 
  jsonlite::stream_out(gzfile("/tmp/cran.json.gz"))

