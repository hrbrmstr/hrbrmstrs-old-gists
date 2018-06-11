library(dplyr)
library(purrr)
library(httr)
library(V8)

# get the data behind https://www.google.com/transparencyreport/safebrowsing/malware/
# this gets the time series aggregate data (at the bottom of ^^)

S_GET <- purrr::safely(httr::GET)

ctx <- v8()

get_as_ts <- function(as, count=TRUE) { # count==FALSE gets %
  
  count <- if (count) "COUNT" else "RATE"
  
  res <- S_GET("https://www.google.com",
               path=sprintf("transparencyreport/jsonp/sb/malware/ts/%s/?a=%s&t=ATTACK&t=COMPROMISED&c=", as, count),
               add_headers(Accept = "*/*", 
                           Referer = "https://www.google.com/transparencyreport/safebrowsing/malware/?hl=en", 
                           `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36"))
  
  if (!is.null(res$result)) {
    
    js <- content(res$result, as="text")
    
    ctx$eval(sprintf("var dat=%s", js))
    
    dat <- data.frame(ctx$get("dat"), stringsAsFactors=FALSE)
    dat$date <- as.Date(as.POSIXct(dat$time.series.1/1000, origin='1970-01-01', tz="UTC"))
    dat <- select(dat,
                  date, asn, name, description, attack=time.series.2, compromised=time.series.3,
                  -sites.types, -time.series.1) 
    
    return(dat)
    
  } else {
    stop("Error retrieving data safesearch detailed asn info", call.=FALSE)
  }
  
}
