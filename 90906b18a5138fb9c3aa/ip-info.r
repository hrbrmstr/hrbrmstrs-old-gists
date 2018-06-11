library(jsonlite)
library(purrr)
library(httr)
library(urltools)
library(tidyr)

`%p+%` <- function(x, y) { paste0(x, y, collapse="") }

safeGET <- safely(GET)

.ip_info <- function(ip_addr=NULL, only_geo=FALSE) {

  base <- "http://ipinfo.io"

  if (!is.null(ip_addr)) { base <- base %p+% "/" %p+% trimws(ip_addr) }
  if (only_geo) { base <- base %p+% "/geo" }

  res <- safeGET(base)

  if (is.null(res$error)) {
    res <- warn_for_status(res$result, "successfully connect with the ipinfo.io API server")
    if (inherits(res, "response")) {
      return(data.frame(fromJSON(content(res, as="text")), stringsAsFactors=FALSE))
    }
  }
  
  return(NULL)

}

ip_info <- function(ips, only_geo=FALSE) {
  map_df(ips, .ip_info, only_geo=only_geo)
}

ip_info(c("foobar/bash", "50.252.233.22", "foobar/bash")) # should warn but not fail

ips <- readLines(textConnection("216.21.192.228
104.200.31.117
91.196.49.186
217.31.54.202
72.76.81.242
192.0.99.106
192.0.100.155
192.0.100.107
67.223.145.151
66.249.69.99
66.102.7.214
86.106.16.246
141.8.142.12
176.61.139.38
150.243.227.214
107.170.119.178
220.181.108.108
220.181.108.96
220.181.108.111
104.236.112.222
216.229.170.227
205.210.42.86
74.125.183.167
192.0.102.40
202.28.250.105
207.46.13.156
184.169.155.79
173.75.43.213
66.249.69.90
123.125.71.49
216.21.192.228
90.202.100.128
212.250.127.100
216.158.220.202
90.202.100.128
208.115.113.91
104.130.173.114
207.46.13.175
8.29.198.26
207.46.13.175
208.115.113.91
180.76.15.136
211.181.165.18
180.76.15.140
202.28.250.105
198.58.103.158
52.18.96.153
174.91.252.217
157.55.39.225
208.115.113.91
180.76.15.22
192.0.99.11
205.210.42.86
104.236.112.222
205.210.42.86
180.76.15.26
180.76.15.10
202.28.250.105"))

dat <- ip_info(ips)

dat_1 <- cbind.data.frame(dat,
                          suffix_extract(dat$hostname)[,2:3],
                          stringsAsFactors=FALSE)

dat_2 <- separate(dat_1, loc, c("lat", "lon"), ",")