library(dplyr)
library(purrr)
library(httr)
library(V8)

# get the data behind https://www.google.com/transparencyreport/safebrowsing/malware/

S_GET <- purrr::safely(httr::GET)

ctx <- v8()

get_as_info_page <- function(page=0,
                             as_size=c("largest", "all"), 
                             time_range=90,
                             type_detected=c("both", "attack", "compromised"),
                             region="all") {
  
  as_size <- toupper(as_size[1])
  type_detected <- toupper(type_detected[1])
  if (region == "all") region <- ""
  
  res <- S_GET("https://www.google.com",
               path="transparencyreport/jsonp/sb/malware/table/",
               query=list(t=type_detected,
                          d=time_range,
                          z=as_size,
                          p=page,
                          r=region,
                          c=""),
               add_headers(Accept = "*/*", 
                           Referer = "https://www.google.com/transparencyreport/safebrowsing/malware/?hl=en", 
                           `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36"))
  
  if (!is.null(res$result)) {
    
    js <- content(res$result, as="text")
    
    ctx$eval(sprintf("var dat=%s", js))
    
    dat <- ctx$get("dat")
    
    return(dat)
    
  } else {
    stop("Error retrieving data safesearch asn info", call.=FALSE)
  }
  
}

get_as_info <- function(as_size=c("largest", "all"), 
                        time_range=90,
                        type_detected=c("both", "attack", "compromised"),
                        region="all",
                        .progress=FALSE) {
  
  first <- get_as_info_page(0, as_size, time_range, type_detected, region)
  
  if (.progress & interactive()) pb <- txtProgressBar(0, first$`page-count`, style=3)

  map_df(1:(first$`page-count`-1), function(pg) {
    if (.progress & interactive()) setTxtProgressBar(pb, pg)
    res <- get_as_info_page(pg, as_size, time_range, type_detected, region)
    res$table
  }) -> asn_tbl_pages
  
  if (.progress & interactive()) close(pb)
  
  dplyr::bind_rows(first$table, asn_tbl_pages)
  
}
