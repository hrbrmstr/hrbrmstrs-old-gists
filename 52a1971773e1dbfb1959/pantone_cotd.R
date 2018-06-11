library(XML)
library(httr)
library(stringr)

pantone_cotd <- function(cotd_url = "https://www.pantone.com/pages/colorstrology/colorstrology.aspx") {
  
  # have to fake a real user agent to get the color  
  agent <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.78.2 (KHTML, like Gecko) Version/7.0.6 Safari/537.78.2"
  
  try(pantone <- GET(cotd_url, user_agent(agent)))
  
  if (class(pantone) == "response") {
    
    tmp <- content(pantone, as="parsed")
    
    pantone.number <- str_extract(unlist(xpathApply(tmp, "//span[@class='numLogon']", xmlValue)), "[0-9\\-]+")
    pantone.name <- unlist(xpathApply(tmp, "//span[@class='nameLogon']", xmlValue))
    pantone.color <- str_match(as.character(getNodeSet(tmp, "//div[@id='ctl00_ctlDynamicControl7_plColorstrologyBackgroundPanel']/@style")), "background\\-color:(#[A-Za-z0-9]+)")[,2]
    
    names(pantone.color) <- sprintf("%s %s", pantone.name, pantone.number)
    return(pantone.color)
    
  } else {
    
    return(`random`=rgb(runif(1),runif(1),runif(1)))
    
  }
  
}
