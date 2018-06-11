library('curlconverter') # https://github.com/hrbrmstr/curlconverter
library('jsonlite')
library('httr')

# http://opendatasicilia.65952.x6.nabble.com/Un-nuovo-portale-sulla-qualita-dell-aria-in-Italia-td2490.html
curl_line <- c('curl "http://anasim.iet.unipi.it/moniqa/php/from_js.php" -H "Origin: http://anasim.iet.unipi.it" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4" -H "User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Referer: http://anasim.iet.unipi.it/moniqa/" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" --data "deviceid=1&function_name=extract_measurements" --compressed')

toJSON(straighten(curl_line, quiet=TRUE), pretty=TRUE)
#[
# {
#    "url": ["http://anasim.iet.unipi.it/moniqa/php/from_js.php"],
#    "method": ["post"],
#    "headers": {
#      "Origin": ["http://anasim.iet.unipi.it"],
#      "Accept-Encoding": ["gzip, deflate"],
#      "Accept-Language": ["it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4"],
#      "User-Agent": ["Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36"],
#      "Content-Type": ["application/x-www-form-urlencoded; charset=UTF-8"],
#      "Accept": ["*/*"],
#      "Referer": ["http://anasim.iet.unipi.it/moniqa/"],
#      "X-Requested-With": ["XMLHttpRequest"],
#      "Connection": ["keep-alive"]
#    },
#    "data": ["deviceid=1&function_name=extract_measurements"],
#    "url_parts": {
#      "scheme": ["http"],
#      "hostname": ["anasim.iet.unipi.it"],
#      "port": {},
#      "path": ["moniqa/php/from_js.php"],
#      "query": {},
#      "params": {},
#      "fragment": {},
#      "username": {},
#      "password": {}
#    }
#  }
#] 

req <- straighten(curl_line, quiet=FALSE)
str(req)

#List of 1
# $ :List of 5
#  ..$ url      : chr "http://anasim.iet.unipi.it/moniqa/php/from_js.php"
#  ..$ method   : chr "post"
#  ..$ headers  :List of 9
#  .. ..$ Origin          : chr "http://anasim.iet.unipi.it"
#  .. ..$ Accept-Encoding : chr "gzip, deflate"
#  .. ..$ Accept-Language : chr "it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4"
#  .. ..$ User-Agent      : chr "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36"
#  .. ..$ Content-Type    : chr "application/x-www-form-urlencoded; charset=UTF-8"
#  .. ..$ Accept          : chr "*/*"
#  .. ..$ Referer         : chr "http://anasim.iet.unipi.it/moniqa/"
#  .. ..$ X-Requested-With: chr "XMLHttpRequest"
#  .. ..$ Connection      : chr "keep-alive"
#  ..$ data     : chr "deviceid=1&function_name=extract_measurements"
#  ..$ url_parts:List of 9
#  .. ..$ scheme  : chr "http"
#  .. ..$ hostname: chr "anasim.iet.unipi.it"
#  .. ..$ port    : NULL
#  .. ..$ path    : chr "moniqa/php/from_js.php"
#  .. ..$ query   : NULL
#  .. ..$ params  : NULL
#  .. ..$ fragment: NULL
#  .. ..$ username: NULL
#  .. ..$ password: NULL

req <- req[[1]]

w <- VERB(verb   = toupper(req$method), # 'POST'
          url    = req$url, 
          config = add_headers(toJSON(req$headers)), 
          body   = parse_query(req$data))
stop_for_status(w)

res <- content(w, as = "text", encoding = "UTF-8")
res <- jsonlite::fromJSON(res)

#> res
#$sensors
#  fk_sensortype
#1             1
#2             2
#3             3
#4             4
#
#$measures
#   measure fk_sensortype          date
#1       87             1 1454889600000
#2       87             2 1454889600000
#3        8             3 1454889600000
#4       56             1 1454893200000
# ...
# ...
