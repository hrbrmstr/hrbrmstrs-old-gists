library(httr)
library(leaflet)

GET("https://ipinfo.io/json") %>% # get IP geolocated coordinates
  content() %>%
  .$loc %>%
  strsplit(",") %>%
  .[[1]] %>%
  as.numeric() -> lat_lng

leaflet() %>%
  addTiles() %>%
  setView(lat_lng[2], lat_lng[1], zoom=10) %>%
  addCircles(lat_lng[2], lat_lng[1], radius=914.4, opacity=1/6) %>%       # instant death/obliteration
  addCircles(lat_lng[2], lat_lng[1], radius=1609.34, opacity=1/6) %>%     # devastating property/human damage
  addCircles(lat_lng[2], lat_lng[1], radius=1.7*1609.34, opacity=1/6) %>% # shock wave devastation
  addCircles(lat_lng[2], lat_lng[1], radius=2*1609.34, opacity=1/6) %>%   # human & animal deafness (usually permanent)
  addCircles(lat_lng[2], lat_lng[1], radius=5*1609.34, opacity=1/6) %>%   # shatters glass
  addCircles(lat_lng[2], lat_lng[1], radius=30*1609.34, opacity=1/6)      # 10,000 foot high mushroom cloud visible.
