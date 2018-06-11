#' ---
#' title: ""
#' author: ""
#' date: ""
#' output:
#'   html_document:
#'     keep_md: true
#'     theme: simplex
#'     highlight: monochrome
#' ---
#+ init, include=FALSE
knitr::opts_chunk$set(message = FALSE, warning = FALSE, dev="png",
                      fig.retina = 2, fig.width = 10, fig.height = 6)

#+ libs
library(stringi)
library(tidyverse)

#+ data, cache=TRUE
options(width=120)
utils <- read_rds(url("https://rud.is/dl/utility-belt.rds"))


#+ filter
utils

filter(utils, stri_detect_fixed(file_src, "`%")) %>% # only find sources with infix definitions
  pull(file_src) %>%
  paste0(collapse="\n\n") %>%
  parse(text = ., keep.source=TRUE) -> infix_src

str(infix_src, 1)

infix_parsed <- tbl_df(getParseData(infix_src))

infix_parsed

# pattern for function definition
pat <- c("SYMBOL", "expr", "LEFT_ASSIGN", "expr", "FUNCTION")

# find all of ^^ sequences (there's a good twitter discussion abt a month ago on this if you can find it)
idx <- which(infix_parsed$token == pat[1]) # find location of match of start of seq

# look for the rest of the sequences starting at each idx position
map_lgl(idx, ~{
  all(infix_parsed$token[.x:(.x+(length(pat)-1))] == pat)
}) -> found

f_defs <- idx[found] # starting indices of all the places where functions are defined

# filter ^^ to only find infix ones
infix_defs <- f_defs[stri_detect_regex(infix_parsed$text[f_defs], "^`\\%")]

# there aren't too many, but remember we're just searching `util` functions
length(infix_defs)

# nuke a file and fill it with the function definition
cat("", sep="", file="infix_functions.R")
walk2(
  getParseText(infix_parsed, infix_parsed$id[infix_defs]),     # extract the infix name
  getParseText(infix_parsed, infix_parsed$id[infix_defs + 3]), # extract the function definition body
  ~{
    cat(.x, " <- ", .y, "\n\n", sep="", file="infix_functions.R", append=TRUE)
  }
)
