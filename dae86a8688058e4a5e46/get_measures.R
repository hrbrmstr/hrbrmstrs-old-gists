library('httr')
library('jsonlite')

get_measures <- function(deviceid) {

  .h <- list(
    "Origin" = "http://anasim.iet.unipi.it",
    "Accept-Encoding" = "gzip, deflate",
    "Accept-Language" = "it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4",
    "User-Agent" = "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36",
    "Content-Type" = "application/x-www-form-urlencoded; charset=UTF-8",
    "Accept" = "*/*",
    "Referer" = "http://anasim.iet.unipi.it/moniqa/",
    "X-Requested-With" = "XMLHttpRequest",
    "Connection" = "keep-alive")

  parseDate <- function(x) as.POSIXct(as.numeric(x) / 1000, origin = "1970-01-01", tz = "UTC")

  req <- POST(url    = "http://anasim.iet.unipi.it/moniqa/php/from_js.php",
              #config = add_headers(toJSON(.h)),
              body   = list(deviceid = deviceid,
                            function_name = "extract_measurements"))

  stop_for_status(req)

  res <- content(req, as = "text", encoding = "UTF-8")
  res <- jsonlite::fromJSON(res)

  z <- res$measures

  z$measure        <- as.numeric(z$measure)
  z$fk_sensortype  <- as.numeric(z$fk_sensortype)
  z$date           <- parseDate(z$date)

  z <- reshape(z, idvar ="date", timevar="fk_sensortype", direction= "wide")
  rownames(z) <- NULL
  z
}

get_measures(deviceid = 3)

#                   date measure.1 measure.2 measure.4 measure.6 measure.8
# 1  2016-02-08 00:00:00        82        83        32        18        NA
# 2  2016-02-08 01:00:00        83       108        32        18       3.4
# 3  2016-02-08 02:00:00        70        94        32        18       3.0
# 4  2016-02-08 03:00:00        NA        NA        32        18       2.6
# ...
# ...
