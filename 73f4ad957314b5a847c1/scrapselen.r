library(xml2)
library(rvest)
library(RSelenium)
library(purrr)

URL <- "http://www.thelugarcenter.org/ourwork-Bipartisan-Index.html"

checkForServer()
startServer()

remDr <- remoteDriver()
remDr$open()
remDr$navigate(URL)

pg_src <- remDr$getPageSource()[[1]]

remDr$close()

pg <- read_html(pg_src)
doc <- html_nodes(pg, "div#tab7-group")

tabs <- html_table(html_nodes(doc, "table"))

lapply(which(sapply(tabs, function(x) sum(is.na(x))) > 110), function(i) {
  tmp <- tabs[[i]][-1:-2, c(-1, -7, -8)]
  rbind(setNames(tmp[,1:5], c("last", "first", "state", "party", "score")),
        setNames(tmp[,6:10], c("last", "first", "state", "party", "score")))
}) -> senate

mutate(bind_rows(setNames(senate, 112:103), .id="congress"), 
       score=as.numeric(score),
       congress=sprintf("%sth", congress)) -> senate

write.csv(senate, "senate_bipartisan_index.csv", row.names=FALSE)
