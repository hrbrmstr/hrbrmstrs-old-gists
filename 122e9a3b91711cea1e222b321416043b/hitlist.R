library(tidyverse)

# in case we have network or site issues
sfj <- safely(jsonlite::fromJSON)

# URLs 1-3600
hit_lists <- sprintf("https://hitlijst.vrt.be/api/lists/%s.json", 1:3600)

# gotta get'em all!
map(hit_lists, ~{
  Sys.sleep(5)
  sfj(.x)
}) -> res

# save the 5 hrs of work
write_rds(res, "res.rds")

str(res[[3480]]$result$data)
## List of 14
##  $ lid         : int 3480
##  $ name        : chr "MNM Urban50 van 20 oktober 2017"
##  $ description : chr ""
##  $ air_date    : int 1508526000
##  $ config      :List of 10
##   ..$ positions    : chr "10"
##   ..$ logo_fid     : int 0
##   ..$ epg_code     : chr ""
##   ..$ epg_enabled  : int 0
##   ..$ epg_position : chr ""
##   ..$ frequency    : chr "week"
##   ..$ visualisation:List of 1
##   .. ..$ showranks: int 1
##   ..$ statistics   :List of 1
##   .. ..$ emotions_voting: chr ""
##   ..$ logo         : NULL
##   ..$ pagination   :List of 2
##   .. ..$ page    : int 0
##   .. ..$ pagesize: chr "10"
##  $ list_type   : chr "song"
##  $ parent_lid  : int 48
##  $ brand_id    : int 55
##  $ active      : NULL
##  $ modified_at : int 1508508338
##  $ created_at  : int 1508503828
##  $ position    : chr "1"
##  $ votings     : list()
##  $ machine_name: chr "mnm_urban50_van_20_oktober_2017"

glimpse(res[[3480]]$result$songs)
## Observations: 10
## Variables: 29
## $ id             <chr> "92303", "95709", "91798", "93332", "93580", "9...
## $ main_artist    <chr> "32036", "33036", "31886", "32336", "32418", "3...
## $ title          <chr> "Feels", "rockstar", "Krantenwijk", "MI GENTE (...
## $ lyrics         <chr> "", "", "", "", NA, "", "", "", "", ""
## $ audio_url      <chr> "https://p.scdn.co/mp3-preview/0c58b32cdd0231ce...
## $ image_url      <chr> "https://hitlijst.vrt.be/sites/default/files/st...
## $ youtube_url    <chr> "https://www.youtube.com/embed/e6SXD3CALWo", "h...
## $ itunes_buy     <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
## $ release_date   <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
## $ distributor_id <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
## $ label_id       <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
## $ language_id    <chr> "", "", "", "", NA, "", "", "", "", ""
## $ enriched       <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"
## $ custom         <chr> NA, NA, NA, NA, "0", NA, NA, NA, NA, NA
## $ modified_at    <chr> "1498221812", "1507292479", "1498221992", "1500...
## $ created_at     <chr> "1498220527", "1506066347", "1497624753", "1500...
## $ uid            <chr> "9", "21", "1", "9", "9", "21", "9", "1", "21",...
## $ import_id      <chr> "1027", "1145", NA, "1070", "1096", "1126", NA,...
## $ image_id       <chr> "55516", "57254", "55517", "55718", "55886", "0...
## $ spotify_id     <chr> "6BaCraQ9xeLYg4Sb9TBT2X", "7wGoVu4Dady5GV0Sv4UI...
## $ quote          <chr> "", "", "", "", NA, "", "", "", "", ""
## $ position       <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
## $ entity_id      <chr> "92303", "95709", "91798", "93332", "93580", "9...
## $ name           <chr> "Calvin Harris feat. Pharrell Williams, Katy Pe...
## $ song_id        <chr> "92303", "95709", "91798", "93332", "93580", "9...
## $ previous       <int> 3, 1, 2, 4, 5, 7, 8, 6, 10, 9
## $ weeksinlist    <int> 16, 4, 16, 14, 10, 7, 2, 16, 4, 15
## $ rank           <list> [<c("1499454000", "1500058800", "1500663600", ...
## $ image          <chr> "https://hitlijst.vrt.be/sites/default/files/st...## 

len0 <- function(x) { length(x) == 0 }
len_gt_1 <- function(x) { length(x) > 1 }

map(res, c("result", "data", "name")) %>% 
  modify_if(len_gt_1, ~.x[1]) %>% 
  modify_if(len0, NA_character_) %>% 
  flatten_chr() -> list_names

tail(list_names)
## [1] "Click-Like40 van vrijdag 5 januari 2018"
## [2] "MNM Urban50 van 5 januari 2018"         
## [3] "MNM Dance50 van zaterdag 6 januari 2018"
## [4] "Ultratop50 van zondag 7 januari 2018"   
## [5] "MNM50 van zaterdag 6 januari 2018"      
## [6] "Vox hitlijst van 6 januari" 

list_dates <- anytime::anytime(map_dbl(res, c("result", "data", "air_date")))

tail(as.Date(list_dates), 20)
##  [1] "2017-12-21" "2017-12-22" "2017-12-23" "2017-12-26" "2017-12-27"
##  [6] "2017-12-28" "2017-12-29" "2017-12-30" "2017-12-24" "2017-12-23"
## [11] "2017-12-22" "2017-12-22" "2017-12-29" "2018-01-01" "2018-01-04"
## [16] "2018-01-05" "2018-01-06" "2018-01-07" "2018-01-06" "2018-01-04"