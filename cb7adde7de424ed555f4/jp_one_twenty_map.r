# create map data ---------------------------------------------------------
library(rvest)
library(dplyr)
library(tidyr)
library(Nippon)
library(rgdal)

url <- "http://www.gsi.go.jp/MAP/HISTORY/20-index20.html" %>% html()
html(url)
names.one.twenty <- vector()
num.one.twenty <- vector()
html_nodes(url, css = "map area") %>% {
  names.one.twenty <<- html_attr(., "alt") %>% kana2roma(.)
  num.one.twenty <<- html_attr(., "href") %>% sub(pattern = "http://www.gsi.go.jp/cgi-bin/zureki/20man.cgi\\?", replacement = "", x = .)
}

res <- data.frame(num.one.twenty, names.one.twenty) # nrow(res) 

## ----  --------------------------------------------------------------------
library(geojsonio)
library(sp)
poly13 <- Polygons(
  list(Polygon(cbind(
    c(148.0, 148.0, 149.0, 149.0, 148.0),
    c(46.0, 45.33333, 45.33333, 46.0, 46.0)))), "1")
poly14 <- Polygons(
  list(Polygon(cbind(
    c(148.0, 148.0, 149.0, 149.0, 148.0),
    c(45.33333, 44.66666, 44.66666, 45.33333, 45.33333)))), "2")
poly15 <- Polygons(
  list(Polygon(cbind(
    c(147.0, 147.0, 148.0, 148.0, 147.0),
    c(45.33333, 44.66666, 44.66666, 45.33333, 45.33333)))), "3")
poly16 <- Polygons(
  list(Polygon(cbind(
    c(147.0, 147.0, 148.0, 148.0, 147.0),
    c(44.66666, 44.0, 44.0, 44.66666, 44.66666)))), "4")
poly25 <- Polygons(
  list(Polygon(cbind(
    c(146.0, 146.0, 147.0, 147.0, 146.0),
    c(44.66666, 44.0, 44.0, 44.66666, 44.66666)))), "5")
poly26 <- Polygons(
  list(Polygon(cbind(
    c(146.0, 146.0, 147.0, 147.0, 146.0),
    c(44.0, 43.33333, 43.33333, 44.0, 44.0)))), "6")
poly27 <- Polygons(
  list(Polygon(cbind(
    c(145.0, 145.0, 146.0, 146.0, 145.0),
    c(44.66666, 44.0, 44.0, 44.66666, 44.66666)))), "7")
poly28 <- Polygons(
  list(Polygon(cbind(
    c(145.0, 145.0, 146.0, 146.0, 145.0),
    c(44.0, 43.33333, 43.33333, 44.0, 44.0)))), "8")
poly29 <- Polygons(
  list(Polygon(cbind(
    c(145.0, 145.0, 146.0, 146.0, 145.0),
    c(43.33333, 42.66666, 42.66666, 43.33333, 43.33333)))), "9")
poly30 <- Polygons(
  list(Polygon(cbind(
    c(144.0, 144.0, 145.0, 145.0, 144.0),
    c(44.66666, 44.0, 44.0, 44.66666, 44.66666)))), "10")
poly31 <- Polygons(
  list(Polygon(cbind(
    c(144.0, 144.0, 145.0, 145.0, 144.0),
    c(44.0, 43.33333, 43.33333, 44.0, 44.0)))), "11")
poly32 <- Polygons(
  list(Polygon(cbind(
    c(144.0, 144.0, 145.0, 145.0, 144.0),
    c(43.33333, 42.66666, 42.66666, 43.33333, 43.33333)))), "12")
poly33 <- Polygons(
  list(Polygon(cbind(
    c(143.0, 143.0, 144.0, 144.0, 143.0),
    c(44.66666, 44.0, 44.0, 44.66666, 44.66666)))), "13")
poly34 <- Polygons(
  list(Polygon(cbind(
    c(143.0, 143.0, 144.0, 144.0, 143.0),
    c(44.0, 43.33333, 43.33333, 44.0, 44.0)))), "14")
poly35 <- Polygons(
  list(Polygon(cbind(
    c(143.0, 143.0, 144.0, 144.0, 143.0),
    c(43.33333, 42.66666, 42.66666, 43.33333, 43.33333)))), "15")
poly36 <- Polygons(
  list(Polygon(cbind(
    c(143.0, 143.0, 144.0, 144.0, 143.0),
    c(42.66666, 42.0, 42.0, 42.66666, 42.66666)))), "16")
poly37 <- Polygons(
  list(Polygon(cbind(
    c(142.0, 142.0, 143.0, 143.0, 142.0),
    c(45.33333, 44.66666, 44.66666, 45.33333, 45.33333)))), "17")
poly38 <- Polygons(
  list(Polygon(cbind(
    c(142.0, 142.0, 143.0, 143.0, 142.0),
    c(44.66666, 44.0, 44.0, 44.66666, 44.66666)))), "18")
poly39 <- Polygons(
  list(Polygon(cbind(
    c(142.0, 142.0, 143.0, 143.0, 142.0),
    c(44.0, 43.33333, 43.33333, 44.0, 44.0)))), "19")
poly40 <- Polygons(
  list(Polygon(cbind(
    c(142.0, 142.0, 143.0, 143.0, 142.0),
    c(43.33333, 42.66666, 42.66666, 43.33333, 43.33333)))), "20")
poly41 <- Polygons(
  list(Polygon(cbind(
    c(142.0, 142.0, 143.0, 143.0, 142.0),
    c(42.66666, 42.0, 42.0, 42.66666, 42.66666)))), "21")
poly42 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(46.0, 45.33333, 45.33333, 46.0, 46.0)))), "22")
poly43 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(45.33333, 44.66666, 44.66666, 45.33333, 45.33333)))), "23")
poly44 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(44.66666, 44.0, 44.0, 44.66666, 44.66666)))), "24")
poly45 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(44.0, 43.33333, 43.33333, 44.0, 44.0)))), "25")
poly46 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(43.33333, 42.66666, 42.66666, 43.33333, 43.33333)))), "26")
poly47 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(42.66666, 42.0, 42.0, 42.66666, 42.66666)))), "27")
poly48 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(42.0, 41.33333, 41.33333, 42.0, 42.0)))), "28")
poly49 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(43.33333, 42.66666, 42.66666, 43.33333, 43.33333)))), "29")
poly50 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(42.66666, 42.0, 42.0, 42.66666, 42.66666)))), "30")
poly51 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(42.0, 41.33333, 41.33333, 42.0, 42.0)))), "31")
poly52 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(42.66666, 42.0, 42.0, 42.66666, 42.66666)))), "32")
poly53 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(42.0, 41.33333, 41.33333, 42.0, 42.0)))), "33")
poly54 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(41.33333, 40.66666, 40.66666, 41.33333, 41.33333)))), "34")
poly55 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(40.66666, 40.0, 40.0, 40.66666, 40.66666)))), "35")
poly56 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(40.0, 39.33333, 39.33333, 40.0, 40.0)))), "36")
poly57 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(39.33333, 38.66666, 38.66666, 39.33333, 39.33333)))), "37")
poly58 <- Polygons(
  list(Polygon(cbind(
    c(141.0, 141.0, 142.0, 142.0, 141.0),
    c(38.66666, 38.0, 38.0, 38.66666, 38.66666)))), "38")
poly59 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(41.33333, 40.66666, 40.66666, 41.33333, 41.33333)))), "39")
poly60 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(40.66666, 40.0, 40.0, 40.66666, 40.66666)))), "40")
poly61 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(40.0, 39.33333, 39.33333, 40.0, 40.0)))), "41")
poly62 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(39.33333, 38.66666, 38.66666, 39.33333, 39.33333)))), "42")
poly63 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(38.66666, 38.0, 38.0, 38.66666, 38.66666)))), "43")
poly64 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(38.0, 37.33333, 37.33333, 38.0, 38.0)))), "44")
poly65 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(37.33333, 36.66666, 36.66666, 37.33333, 37.33333)))), "45")
poly66 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(36.66666, 36.0, 36.0, 36.66666, 36.66666)))), "46")
poly67 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(36.0, 35.33333, 35.33333, 36.0, 36.0)))), "47")
poly68 <- Polygons(
  list(Polygon(cbind(
    c(140.0, 140.0, 141.0, 141.0, 140.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "48")
poly69 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(40.66666, 40.0, 40.0, 40.66666, 40.66666)))), "49")
poly70 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(40.0, 39.33333, 39.33333, 40.0, 40.0)))), "50")
poly71 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(39.33333, 38.66666, 38.66666, 39.33333, 39.33333)))), "51")
poly72 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(38.66666, 38.0, 38.0, 38.66666, 38.66666)))), "52")
poly73 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(38.0, 37.33333, 37.33333, 38.0, 38.0)))), "53")
poly74 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(37.33333, 36.66666, 36.66666, 37.33333, 37.33333)))), "54")
poly75 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(36.66666, 36.0, 36.0, 36.66666, 36.66666)))), "55")
poly76 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(36.0, 35.33333, 35.33333, 36.0, 36.0)))), "56")
poly77 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "57")
poly78 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "58")
poly79 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(34.0, 33.33333, 33.33333, 34.0, 34.0)))), "59")
poly80 <- Polygons(
  list(Polygon(cbind(
    c(138.0, 138.0, 139.0, 139.0, 138.0),
    c(38.66666, 38.0, 38.0, 38.66666, 38.66666)))), "60")
poly81 <- Polygons(
  list(Polygon(cbind(
    c(138.0, 138.0, 139.0, 139.0, 138.0),
    c(38.0, 37.33333, 37.33333, 38.0, 38.0)))), "61")
poly82 <- Polygons(
  list(Polygon(cbind(
    c(138.0, 138.0, 139.0, 139.0, 138.0),
    c(37.33333, 36.66666, 36.66666, 37.33333, 37.33333)))), "62")
poly83 <- Polygons(
  list(Polygon(cbind(
    c(138.0, 138.0, 139.0, 139.0, 138.0),
    c(36.66666, 36.0, 36.0, 36.66666, 36.66666)))), "63")
poly84 <- Polygons(
  list(Polygon(cbind(
    c(138.0, 138.0, 139.0, 139.0, 138.0),
    c(36.0, 35.33333, 35.33333, 36.0, 36.0)))), "64")
poly85 <- Polygons(
  list(Polygon(cbind(
    c(138.0, 138.0, 139.0, 139.0, 138.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "65")
poly86 <- Polygons(
  list(Polygon(cbind(
    c(138.0, 138.0, 139.0, 139.0, 138.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "66")
####
poly87 <- Polygons(
  list(Polygon(cbind(
    c(136.5, 136.5, 137.5, 137.5, 136.5),
    c(38.0, 37.33333, 37.33333, 38.0, 38.0)))), "67") ##### 
poly88 <- Polygons(
  list(Polygon(cbind(
    c(137.0, 137.0, 138.0, 138.0, 137.0),
    c(37.33333, 36.66666, 36.66666, 37.33333, 37.33333)))), "68")
poly89 <- Polygons(
  list(Polygon(cbind(
    c(137.0, 137.0, 138.0, 138.0, 137.0),
    c(36.66666, 36.0, 36.0, 36.66666, 36.66666)))), "69")
poly90 <- Polygons(
  list(Polygon(cbind(
    c(137.0, 137.0, 138.0, 138.0, 137.0),
    c(36.0, 35.33333, 35.33333, 36.0, 36.0)))), "70")
poly91 <- Polygons(
  list(Polygon(cbind(
    c(137.0, 137.0, 138.0, 138.0, 137.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "71")
poly92 <- Polygons(
  list(Polygon(cbind(
    c(137.0, 137.0, 138.0, 138.0, 137.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "72")
poly93 <- Polygons(
  list(Polygon(cbind(
    c(136.0, 136.0, 137.0, 137.0, 136.0),
    c(37.33333, 36.66666, 36.66666, 37.33333, 37.33333)))), "73")
poly94 <- Polygons(
  list(Polygon(cbind(
    c(136.0, 136.0, 137.0, 137.0, 136.0),
    c(36.66666, 36.0, 36.0, 36.66666, 36.66666)))), "74")
poly95 <- Polygons(
  list(Polygon(cbind(
    c(136.0, 136.0, 137.0, 137.0, 136.0),
    c(36.0, 35.33333, 35.33333, 36.0, 36.0)))), "75")
poly96 <- Polygons(
  list(Polygon(cbind(
    c(136.0, 136.0, 137.0, 137.0, 136.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "76")
poly97 <- Polygons(
  list(Polygon(cbind(
    c(136.0, 136.0, 137.0, 137.0, 136.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "77")
poly98 <- Polygons(
  list(Polygon(cbind(
    c(136.0, 136.0, 137.0, 137.0, 136.0),
    c(34.0, 33.33333, 33.33333, 34.0, 34.0)))), "78")
poly99 <- Polygons(
  list(Polygon(cbind(
    c(135.0, 135.0, 136.0, 136.0, 135.0),
    c(36.0, 35.33333, 35.33333, 36.0, 36.0)))), "79")
poly100 <- Polygons(
  list(Polygon(cbind(
    c(135.0, 135.0, 136.0, 136.0, 135.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "80")
poly101 <- Polygons(
  list(Polygon(cbind(
    c(135.0, 135.0, 136.0, 136.0, 135.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "81")
poly102 <- Polygons(
  list(Polygon(cbind(
    c(135.0, 135.0, 136.0, 136.0, 135.0),
    c(34.0, 33.33333, 33.33333, 34.0, 34.0)))), "82")
poly103 <- Polygons(
  list(Polygon(cbind(
    c(134.0, 134.0, 135.0, 135.0, 134.0),
    c(36.0, 35.33333, 35.33333, 36.0, 36.0)))), "83")
poly104 <- Polygons(
  list(Polygon(cbind(
    c(134.0, 134.0, 135.0, 135.0, 134.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "84")
poly105 <- Polygons(
  list(Polygon(cbind(
    c(134.0, 134.0, 135.0, 135.0, 134.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "85")
poly106 <- Polygons(
  list(Polygon(cbind(
    c(134.0, 134.0, 135.0, 135.0, 134.0),
    c(34.0, 33.33333, 33.33333, 34.0, 34.0)))), "86")
poly107 <- Polygons(
  list(Polygon(cbind(
    c(133.0, 133.0, 134.0, 134.0, 133.0),
    c(36.66666, 36.0, 36.0, 36.66666, 36.66666)))), "87")
poly108 <- Polygons(
  list(Polygon(cbind(
    c(133.0, 133.0, 134.0, 134.0, 133.0),
    c(36.0, 35.33333, 35.33333, 36.0, 36.0)))), "88")
poly109 <- Polygons(
  list(Polygon(cbind(
    c(133.0, 133.0, 134.0, 134.0, 133.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "89")
poly110 <- Polygons(
  list(Polygon(cbind(
    c(133.0, 133.0, 134.0, 134.0, 133.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "90")
poly111 <- Polygons(
  list(Polygon(cbind(
    c(133.0, 133.0, 134.0, 134.0, 133.0),
    c(34.0, 33.33333, 33.33333, 34.0, 34.0)))), "91")
poly112 <- Polygons(
  list(Polygon(cbind(
    c(133.0, 133.0, 134.0, 134.0, 133.0),
    c(33.33333, 32.66666, 32.66666, 33.33333, 33.33333)))), "92")
poly113 <- Polygons(
  list(Polygon(cbind(
    c(132.0, 132.0, 133.0, 133.0, 132.0),
    c(36.0, 35.33333, 35.33333, 36.0, 36.0)))), "93")
poly114 <- Polygons(
  list(Polygon(cbind(
    c(132.0, 132.0, 133.0, 133.0, 132.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "94")
poly115 <- Polygons(
  list(Polygon(cbind(
    c(132.0, 132.0, 133.0, 133.0, 132.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "95")
poly116 <- Polygons(
  list(Polygon(cbind(
    c(132.0, 132.0, 133.0, 133.0, 132.0),
    c(34.0, 33.33333, 33.33333, 34.0, 34.0)))), "96")
poly117 <- Polygons(
  list(Polygon(cbind(
    c(132.0, 132.0, 133.0, 133.0, 132.0),
    c(33.33333, 32.66666, 32.66666, 33.33333, 33.33333)))), "97")
poly118 <- Polygons(
  list(Polygon(cbind(
    c(131.0, 131.0, 132.0, 132.0, 131.0),
    c(35.33333, 34.66666, 34.66666, 35.33333, 35.33333)))), "98")
poly119 <- Polygons(
  list(Polygon(cbind(
    c(131.0, 131.0, 132.0, 132.0, 131.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "99")
poly120 <- Polygons(
  list(Polygon(cbind(
    c(131.0, 131.0, 132.0, 132.0, 131.0),
    c(34.0, 33.33333, 33.33333, 34.0, 34.0)))), "100")
poly121 <- Polygons(
  list(Polygon(cbind(
    c(131.0, 131.0, 132.0, 132.0, 131.0),
    c(33.33333, 32.66666, 32.66666, 33.33333, 33.33333)))), "101")
poly122 <- Polygons(
  list(Polygon(cbind(
    c(131.0, 131.0, 132.0, 132.0, 131.0),
    c(32.66666, 32.0, 32.0, 32.66666, 32.66666)))), "102")
poly123 <- Polygons(
  list(Polygon(cbind(
    c(131.0, 131.0, 132.0, 132.0, 131.0),
    c(32.0, 31.33333, 31.33333, 32.0, 32.0)))), "103")
poly124 <- Polygons(
  list(Polygon(cbind(
    c(130.0, 130.0, 131.0, 131.0, 130.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "104")
poly125 <- Polygons(
  list(Polygon(cbind(
    c(130.0, 130.0, 131.0, 131.0, 130.0),
    c(34.0, 33.33333, 33.33333, 34.0, 34.0)))), "105")
poly126 <- Polygons(
  list(Polygon(cbind(
    c(130.0, 130.0, 131.0, 131.0, 130.0),
    c(33.33333, 32.66666, 32.66666, 33.33333, 33.33333)))), "106")
poly127 <- Polygons(
  list(Polygon(cbind(
    c(130.0, 130.0, 131.0, 131.0, 130.0),
    c(32.66666, 32.0, 32.0, 32.66666, 32.66666)))), "107")
poly128 <- Polygons(
  list(Polygon(cbind(
    c(130.0, 130.0, 131.0, 131.0, 130.0),
    c(32.0, 31.33333, 31.33333, 32.0, 32.0)))), "108")
poly129 <- Polygons(
  list(Polygon(cbind(
    c(130.0, 130.0, 131.0, 131.0, 130.0),
    c(31.33333, 30.66666, 30.66666, 31.33333, 31.33333)))), "109")
poly130 <- Polygons(
  list(Polygon(cbind(
    c(129.0, 129.0, 130.0, 130.0, 129.0),
    c(34.66666, 34.0, 34.0, 34.66666, 34.66666)))), "110")
poly131 <- Polygons(
  list(Polygon(cbind(
    c(129.0, 129.0, 130.0, 130.0, 129.0),
    c(34.0, 33.33333, 33.33333, 34.0, 34.0)))), "111")
poly132 <- Polygons(
  list(Polygon(cbind(
    c(129.0, 129.0, 130.0, 130.0, 129.0),
    c(33.33333, 32.66666, 32.66666, 33.33333, 33.33333)))), "112")
poly133 <- Polygons(
  list(Polygon(cbind(
    c(129.0, 129.0, 130.0, 130.0, 129.0),
    c(32.66666, 32.0, 32.0, 32.66666, 32.66666)))), "113")
poly134 <- Polygons(
  list(Polygon(cbind(
    c(129.0, 129.0, 130.0, 130.0, 129.0),
    c(32.0, 31.33333, 31.33333, 32.0, 32.0)))), "114")
poly135 <- Polygons(
  list(Polygon(cbind(
    c(129.0, 129.0, 130.0, 130.0, 129.0),
    c(31.33333, 30.66666, 30.66666, 31.33333, 31.33333)))), "115")
poly136 <- Polygons(
  list(Polygon(cbind(
    c(128.0, 128.0, 129.0, 129.0, 128.0),
    c(33.33333, 32.66666, 32.66666, 33.33333, 33.33333)))), "116")
poly137 <- Polygons(
  list(Polygon(cbind(
    c(128.0, 128.0, 129.0, 129.0, 128.0),
    c(32.66666, 32.0, 32.0, 32.66666, 32.66666)))), "117")
poly141 <- Polygons(
  list(Polygon(cbind(
    c(139.0, 139.0, 140.0, 140.0, 139.0),
    c(33.33333, 32.66666, 32.66666, 33.33333, 33.33333)))), "118")
poly153 <- Polygons(
  list(Polygon(cbind(
    c(130.0, 130.0, 131.0, 131.0, 130.0),
    c(30.66666, 30.0, 30.0, 30.66666, 30.66666)))), "119")
poly154 <- Polygons(
  list(Polygon(cbind(
    c(129.0, 129.0, 130.0, 130.0, 129.0),
    c(30.0, 29.33333, 29.33333, 30.0, 30.0)))), "120")
poly155 <- Polygons(
  list(Polygon(cbind(
    c(129.0, 129.0, 130.0, 130.0, 129.0),
    c(29.33333, 28.66666, 28.66666, 29.33333, 29.33333)))), "121")
poly156 <- Polygons(
  list(Polygon(cbind(
    c(129.0, 129.0, 130.0, 130.0, 129.0),
    c(28.66666, 28.0, 28.0, 28.66666, 28.66666)))), "122")
poly157 <- Polygons(
  list(Polygon(cbind(
    c(128.0, 128.0, 129.0, 129.0, 128.0),
    c(28.0, 27.33333, 27.33333, 28.0, 28.0)))), "123")
poly158 <- Polygons(
  list(Polygon(cbind(
    c(127.5, 127.5, 128.5, 128.5, 127.5),
    c(27.33333, 26.66666, 26.66666, 27.33333, 27.33333)))), "124")
poly161 <- Polygons(
  list(Polygon(cbind(
    c(127.5, 127.5, 128.5, 128.5, 127.5),
    c(26.66666, 26.0, 26.0, 26.66666, 26.66666)))), "125")
poly162 <- Polygons(
  list(Polygon(cbind(
    c(126.5, 126.5, 127.5, 127.5, 126.5),
    c(26.66666, 26.0, 26.0, 26.66666, 26.66666)))), "126")
poly163 <- Polygons(
  list(Polygon(cbind(
    c(124.5, 124.5, 125.5, 125.5, 124.5),
    c(25.0, 24.33333, 24.33333, 25.0, 25.0)))), "127")
poly164 <- Polygons(
  list(Polygon(cbind(
    c(123.0, 123.0, 124.0, 124.0, 123.0),
    c(26.0, 25.33333, 25.33333, 26.0, 26.0)))), "128")
poly166 <- Polygons(
  list(Polygon(cbind(
    c(123.5, 123.5, 124.5, 124.5, 123.5),
    c(24.66666, 24.0, 24.0, 24.66666, 24.66666)))), "129")
poly170 <- Polygons(
  list(Polygon(cbind(
    c(142.0, 142.0, 143.0, 143.0, 142.0),
    c(27.33333, 26.66666, 26.66666, 27.33333, 27.33333)))), "130")

tmp <- SpatialPolygons(Srl = list(poly13, poly14, poly15, poly16,
                                  poly25, poly26, poly27, poly28, poly29,
                                  poly30, poly31, poly32,
                                  poly33, poly34, poly35, poly36,
                                  poly37, poly38, poly39, poly40, poly41,
                                  poly42, poly43, poly44, poly45, poly46, poly47, poly48,
                                  poly49, poly50, poly51,
                                  poly52, poly53,
                                  poly54, poly55, poly56, poly57, poly58,
                                  poly59, poly60, poly61, poly62, poly63, poly64, poly65, poly66, poly67, poly68,
                                  poly69, poly70, poly71, poly72, poly73, poly74, poly75, poly76, poly77, poly78, poly79,
                                  poly80, poly81, poly82, poly83, poly84, poly85, poly86,
                                  poly87, poly88, poly89, poly90, poly91, poly92,
                                  poly93, poly94, poly95, poly96, poly97, poly98,
                                  poly99, poly100, poly101, poly102,
                                  poly103, poly104, poly105, poly106,
                                  poly107, poly108, poly109, poly110, poly111, poly112,
                                  poly113, poly114, poly115, poly116, poly117,
                                  poly118, poly119, poly120, poly121, poly122, poly123,
                                  poly124, poly125, poly126, poly127, poly128, poly129,
                                  poly130, poly131, poly132, poly133, poly134, poly135,
                                  poly136, poly137,
                                  poly141, 
                                  poly153, poly154, poly155, poly156, poly157, poly158, poly161, poly162,
                                  poly163, poly164, poly166,
                                  poly170), 
                       pO = 1:130)
SpatialPolygonsDataFrame(tmp, res[1:130, ]) %>% geojson_json(., geometry = "polygon")
# copy then paste to gist
# SpatialPolygonsDataFrame(tmp, res[1:130, ]) %>% geojson_json(.) %>% readOGR(., "OGRGeoJSON") %>% plot(.)
# make mapping data ------------------------------------------------------------
set.seed(100)
res$dummy.data <- rgamma(nrow(res), shape = 5, scale = 20)
jp.map.data <- SpatialPolygonsDataFrame(tmp, res[1:130, ]) %>% geojson_json(.) %>% readOGR(., "OGRGeoJSON")
## ---- plot --------------------------------------------------------------------
library(rgdal)
library(ggplot2)
library(rgeos)
# use abobe map data from: https://gist.github.com/uribo/b09d642351c03dd975aa
url <- "https://gist.githubusercontent.com/uribo/b09d642351c03dd975aa/raw/96b36aee705814b6cf651dcf3a566be0b0f74803/japan_one_twenty_map.topojson"
readOGR(url, "OGRGeoJSON") %>% plot(.)
# ogrInfo(url, "OGRGeoJSON")
# labeling data with ggplot2 ---------------------------------------------------
jp.map <- readOGR(url, "OGRGeoJSON") %>% fortify(., region = "names.one.twenty")
centers <- readOGR(url, "OGRGeoJSON") %>% 
  gCentroid(., byid = TRUE) %>% 
  data.frame(., id = jp.map.data@data$names.one.twenty) %>% 
  cbind.data.frame()

ggplot() + 
  geom_map(data = jp.map, map = jp.map,
                    aes(x = long, y = lat, map_id = id),
                    color = "white", size = 0.5) +
  geom_map(data = jp.map.data@data, map = jp.map,
                    aes(fill = dummy.data, map_id = names.one.twenty)) +
  geom_map(data = jp.map.data@data, map = jp.map,
                    aes(map_id = names.one.twenty),
                    fill = "#ffffff", alpha = 0, color = "white",
                    show_guide = FALSE) + 
  scale_fill_distiller(palette = "RdPu", na.value = "#7f7f7f") +
  geom_text(data = centers, 
            aes(label = id, x = x, y = y), color = "white", size = 2) +
  coord_map() +
  labs(x = NULL, y = NULL) + 
  theme_bw() + 
  theme(panel.border = element_blank())