library(rvest)
library(xml2)
library(jsonlite)

pg <- read_html("http://www.502data.com/counties")
tmp <- readLines(textConnection(html_text(html_nodes(pg, xpath="//script")[8])))
tmp <- sub("^\ +\\$scope.county_rows = ", "", tail(head(tmp, -4), -3))
tmp <- sub(";$", "", tmp)

head(fromJSON(tmp))
