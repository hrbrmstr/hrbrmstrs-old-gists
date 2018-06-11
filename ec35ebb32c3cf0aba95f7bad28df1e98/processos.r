library(RSelenium)
library(rvest)
library(dplyr)
library(pbapply)

URL <- "http://outorgaonerosa.prefeitura.sp.gov.br/relatorios/RelSituacaoGeralProcessos.aspx"

checkForServer()
startServer()
remDr <- remoteDriver$new()
remDr$open()

remDr$navigate(URL)

pblapply(1:69, function(i) {
  
  if (i %in% seq(1, 69, 10)) {
    
    # the first item on the page is not a link but we can just grab the page
    
    pg <- read_html(remDr$getPageSource()[[1]])
    ret <- html_table(html_nodes(pg, "table")[[3]], header=TRUE)
    
  } else {
    
    # we can get the rest of them by the link text directly
    
    ref <- remDr$findElements("xpath", sprintf(".//a[contains(@href, 'javascript:__doPostBack') and .='%s']", i))
    ref[[1]]$clickElement()
    pg <- read_html(remDr$getPageSource()[[1]])
    ret <- html_table(html_nodes(pg, "table")[[3]], header=TRUE)
    
  }
  
  # we have to move to the next actual page of data after every 10 links
  
  if ((i %% 10) == 0) {
    ref <- remDr$findElements("xpath", ".//a[.='...']")
    ref[[length(ref)]]$clickElement()
  }
  
  ret
  
}) -> tabs

final_dat <- bind_rows(tabs)
final_dat <- final_dat[, c(1, 2, 5, 7, 8, 13, 14)] # the cols you want
final_dat <- final_dat[complete.cases(final_dat),] # take care of NAs

remDr$quit()