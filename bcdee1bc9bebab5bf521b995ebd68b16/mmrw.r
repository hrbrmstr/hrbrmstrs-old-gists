library(httr)

get_mmwr <- function(year, week) {
  
  res <- GET("https://wonder.cdc.gov/mmwr/mmwr_reps.asp",
             query=list(mmwr_year = year, 
                        mmwr_week = sprintf("%02d", as.numeric(week)), 
                        mmwr_table = "4A", 
                        request = "Export", 
                        mmwr_location = "Click here for all Locations"))
  
  tmp <- content(res, as="text", encoding="UTF-8") 
  
  con <- textConnection(tmp)
  tmp <- readLines(con)
  close(con)
  
  start <- which(grepl("tab delimited", tmp)) + 1
  end <- which(grepl("^TOTAL", tmp)) - 1
  
  tmp <- read.table(text=tmp[start:end], na.strings="-", 
                    stringsAsFactors=FALSE, sep="\t")[,1:8]
  tmp <- setNames(tmp, c("area", "all_all", "all_65", "all_45", "all_25",
                         "all_1", "all_infant", "influenza"))
  tmp[,2:8] <- suppressWarnings(lapply(tmp[,2:8], as.numeric))
  tmp$year <- year
  tmp$week <- week
  tmp

}

tst_1 <- get_mmwr(1996, 1)
tst_2 <- get_mmwr(1997, 52)
tst_3 <- get_mmwr(2014, 10)

library(purrr)

map_df(1996:1997, function(yr) {
  map_df(1:2, function(mo) {
    get_mmwr(yr, mo)
  })
})