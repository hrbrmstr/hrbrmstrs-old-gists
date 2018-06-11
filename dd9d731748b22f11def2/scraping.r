library(rvest)
library(dplyr)
library(pbapply)

urls <- c("http://www.privacyrights.org/data-breach/new",
          sprintf("http://www.privacyrights.org/data-breach/new?title=&page=%d", 1:91))

pblapply(urls, function(URL) {
  
  pg <- read_html(URL)

  tab <- html_nodes(pg, "table")[2] 
  rows <- html_nodes(tab, "tr:not(.data-breach-bottom)")
  
  bind_rows(lapply(seq(2, length(rows)-2, by=2), function(i) {
    
    tds_1 <- html_nodes(rows[i], "td")
    tds_2 <- html_nodes(rows[i+1], "td") %>% html_text(trim=TRUE)
    
    data_frame(date_public=html_text(tds_1[1], TRUE),
               name_loc=html_text(tds_1[2], TRUE),
               entity=html_text(tds_1[3], TRUE),
               type=html_text(tds_1[4], TRUE),
               recs=html_text(tds_1[5], TRUE),
               descr=tds_2[1])
    
  }))
  
}) -> things

