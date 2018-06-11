library(tidyverse)

s_parse <- safely(parse) # prevents parse() from borking on malformed R files

list.files("~/projects", pattern=".*\\.[Rr]$", full.names=TRUE, recursive = TRUE) %>% # sub out for your own dir
  map(s_parse) %>% # parse!
  map("result") %>%  # we used safely() so need to get to get to the "result"
  discard(is.null) %>%  # get rid of empty results 
  unlist() %>%  # we don't care which file the library() calls are in
  keep(is.language) %>% # I'm 99% sure only the next line is required but it's not like we're moving slowly
  discard(is.symbol) %>% # get rid of symbols
  keep(~.x[[1]] == "library") %>% # match for a library call
  map(~match.call(library, .x)) %>% # formalize it since folks cld be using named parameters in any order
  map_chr(~as.character(.x[2])) %>%  # get the package names as a character vector
  unique() %>% # only care abt unique ones
  sort() # i blame sesame street for me wanting these in alphabetical order

##  [1] "bomrang"      "cdcfluview"   "circlepackeR" "countrycode"  "curl"         "data.table"   "data.tree"    "dplyr"       
##  [9] "extrafont"    "fishpals"     "forcats"      "ggalt"        "ggiraph"      "ggmap"        "ggplot2"      "ggridges"    
## [17] "ggTimeSeries" "gh"           "grid"         "gridExtra"    "gridSVG"      "gutenbergr"   "here"         "hrbrthemes"  
## [25] "htmltools"    "httr"         "jericho"      "jsonlite"     "knitr"        "lubridate"    "magick"       "mapproj"     
## [33] "maptools"     "metis"        "ndjson"       "neiss"        "pbapply"      "plotly"       "pressur"      "processx"    
## [41] "rappalyzer"   "raster"       "RColorBrewer" "rgdal"        "rgeolocate"   "rgeos"        "robotstxt"    "rprojroot"   
## [49] "rsvg"         "rtweet"       "rvest"        "semver"       "sergeant"     "shiny"        "stackr"       "statebins"   
## [57] "stringi"      "sugrrants"    "svglite"      "testthat"     "tidytext"     "tidyverse"    "tokenizers"   "treemap"     
## [65] "urltools"     "viridis"      "warrc"        "xml2"  
