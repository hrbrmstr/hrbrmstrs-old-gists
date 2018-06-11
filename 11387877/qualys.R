library(RCurl)
library(XML)
library(plyr)

#' get the Qualys SSL Labs rating for a domain+cert
#' 
#' @param site domain to test SSL configuration of
#' @param ip address of \code{site} (will resolve it and take\cr
#'  first response if not specified, but that may not always work as you expect)
#' @param hide.results ["on"|"off"] should the results show up in the SSL Labs history (default "on")
#' @param pause timeout between tries (default 5s)
#' @param curl.opts options to pass to \code{getURL} i.e. proxy setting
#' @return data frame of results
#' 


get_rating <- function(site="rud.is", ip="", hide.results="on", pause=5, curl.opts=list()) {
  
  # try to resolve IP if not specified; if no IP can be found, return
  # a "NA" data frame
  
  if (ip == "") {
    tmp <- nsl(site)
    if (is.null(tmp)) { return(data.frame(site=site, ip=NA, Certificate=NA, 
                                          Protocol.Support=NA, Key.Exchange=NA, Cipher.Strength=NA)) }
    ip <- tmp
  }
  
  # need to let it actually process the certificate if not already cached
  
  rating.dat <- getURL(sprintf("https://www.ssllabs.com/ssltest/analyze.html?d=%s&s=%s&ignoreMismatch=on&hideResults=%s", site, ip, hide.results), .opts=curl.opts)
  while(!grepl("(Overall Rating|Assessment failed)", rating.dat)) {    
    Sys.sleep(pause)
    rating.dat <- getURL(sprintf("https://www.ssllabs.com/ssltest/analyze.html?d=%s&s=%s&ignoreMismatch=on&hideResults=%s", site, ip, hide.results), .opts=curl.opts)
  }
  
  if (grepl("Assessment failed", rating.dat)) {
    return(data.frame(site=site, ip=NA, Certificate=NA, 
                      Protocol.Support=NA, Key.Exchange=NA, Cipher.Strength=NA))
  }
  
  x <- htmlTreeParse(rating.dat, useInternalNodes = TRUE)
  
  # sometimes there is a <span ...> tag in the <div>, which will result in an
  # empty list() object being returned. we check for that and handle it
  # appropriately.
  
  rating <- xmlValue(x[["//div[starts-with(@class,'rating_')]/text()"]])
  if (class(rating) == "list") {
    rating <- xmlValue(x[["//div[starts-with(@class,'rating_')]/span/text()"]])
  }
  
  # extract the XML objects for the ratings labels & values
  
  labs <- getNodeSet(x,"//div[@class='chartBody']/div[@class='chartRow']/div[@class='chartLabel']")
  vals <- getNodeSet(x,"//div[@class='chartBody']/div[@class='chartRow']/div[starts-with(@class,'chartValue')]")
  
  # convert them to vectors
  
  labs <- xpathSApply(labs[[1]], "//div[@class='chartLabel']/text()", xmlValue)
  vals <- xpathSApply(vals[[1]], "//div[starts-with(@class,'chartValue')]/text()", xmlValue)
  
  # make them into a data frame
  
  rating.result <- data.frame(site=site, ip=ip, rating=rating, rbind(vals), row.names=NULL)
  colnames(rating.result) <- c("site", "ip", "rating", gsub(" ", "\\.", labs))
  
  return(rating.result)
  
}

sites <- c("rud.is", "stackoverflow.com", "er-ant.com")
ratings <- ldply(sites, get_rating)
ratings
##                site              ip rating Certificate Protocol.Support Key.Exchange Cipher.Strength
## 1            rud.is  184.106.97.102      B         100               70           80              90
## 2 stackoverflow.com 198.252.206.140      A         100               90           80              90
## 3        er-ant.com            <NA>   <NA>        <NA>             <NA>         <NA>            <NA>