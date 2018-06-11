library(purrr)

script <-  '
library(js) ; library(foo)
#
library("V8")
ls()
library(package=rvest)
TRUE
library(package="hrbrthemes")
1 + 1
library(quietly=TRUE, "ggplot2")
library(quietly=TRUE, package=dplyr, verbose=TRUE)
'
x <- parse(textConnection(script))

keep(x, is.language) %>% 
  keep(~languageEl(.x, 1) == "library") %>% 
  map(as.call) %>% 
  map(match.call, definition = library) %>% 
  map_chr(~capture.output(print(.x))) %>% 
  walk(cat, "\n")
## library(package = js) 
## library(package = foo) 
## library(package = "V8") 
## library(package = rvest) 
## library(package = "hrbrthemes") 
## library(package = "ggplot2", quietly = TRUE) 
## library(package = dplyr, quietly = TRUE, verbose = TRUE) 