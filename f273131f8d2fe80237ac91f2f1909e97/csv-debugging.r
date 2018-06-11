library(stringi)
library(tidyverse)

stri_read_lines("csvfile.csv") %>% 
  stri_split_fixed(",") -> tmp

hdr <- tmp[1]
tmp <- tmp[-1]

unique(lengths(tmp))
# this shld be a single #
# if it's not then

table(lengths(tmp))
# that figures out what the most common # of fields are
# that shld be the same as in hdr

bad <- which(lengths(tmp) != the_most_common_field_length)
good <- which(lengths(tmp) == the_most_common_field_length)

map_df(tmp[good], ~{
  as.list(.x) %>% 
    set_names(c(THE_HEADER_VALUES))
}) -> good_df

# i have a conference call to join ;-)