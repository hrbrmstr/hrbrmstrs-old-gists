library(magick)
library(purrr)

base_url <- "http://www.myfoxhurricane.com/custom/models/gfsext/gfs_atl_winds_%s.png"

sprintf(base_url, 2:93) %>% 
  map(image_read) %>% 
  image_join() %>% 
  image_animate()
