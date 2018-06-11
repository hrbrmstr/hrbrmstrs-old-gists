library(stringi)
library(tidyverse)

l <- stri_read_lines("/tmp/a")

starts <- which(stri_match_first_regex(l, "^([[:alnum:]])")[,2] %in% c("p", "f"))
ends <- c(starts[-1]-1, length(l))

map2_df(starts, ends, ~{
  
  stri_match_first_regex(
    l[.x:.y], 
    "^(a|c|C|d|D|f|F|G|g|i|K|k|l|L|m|n|N|o|p|P|r|R|s|S|t|TQR=|TQR=|TQS=|TSO=|TSS=|TST=|TTF=|TWR=|TWW=|u|z|Z|0|1|2|3|4|5|6|7|8|9)(.*)$"
  )[,2:3] -> recs
  
  setNames(as.list(recs[,2]), stri_replace_last_fixed(recs[,1], "=", ""))
  
}) %>% 
  glimpse()
