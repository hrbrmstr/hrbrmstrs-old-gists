library(stringi)
library(tidyverse)

list.files("~/Development/metasploit-framework/modules", recursive = TRUE, full.names = TRUE) %>% 
  map_df(~{
    dat <- read_lines(.x)
    data_frame(
      fil = basename(.x),
      contents = list(
        dat %>% 
          keep(stri_detect_fixed, "RPORT") %>% 
          keep(stri_detect_regex, "[[:digit:]]")
      ),
      name = dat %>% keep(stri_detect_fixed, "'Name'") %>% .[1]
    )
  }) %>% 
  filter(lengths(contents) > 0) %>% 
  unnest(contents) %>% 
  mutate(contents = stri_trim_both(contents)) %>% 
  mutate(contents = stri_match_first_regex(contents, "Opt::RPORT\\(([[:digit:]]+)\\)")[,2]) %>%  # yes, this misses a cpl edge cases
  filter(!is.na(contents)) %>% 
  mutate(name = stri_match_first_regex(name, "=> (.*)$")[,2]) %>% 
  mutate(name = stri_replace_all_regex(name, "^'|'.*$", "")) %>% 
  select(msp_module=1, port=3, name=2) %>% 
  write_csv("msp-modules-by-port.csv")
