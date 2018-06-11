library(tigris)
library(rvest)
library(leaflet)
library(dplyr)
library(magrittr)
library(stringr)
library(httr)
library(pbapply)

url <- "https://www.texastribune.org/directory/"
xpath <- '//*[@id="texas_house_tab"]/div/div/table'
ua <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.61 Safari/537.36"

url %>%
  html_session(encoding = "UTF-8", user_agent(ua)) %>%
  html_nodes(xpath = xpath) %>%
  html_table(fill = TRUE) %>%
  extract2(1) %>% 
  mutate(id=as.character(District)) -> df

head(df)

img_path <- '//*[@id="wrapper"]/div[3]/img'

pblapply(1:150, function(district) {

  u1 <- paste0('http://www.house.state.tx.us/members/member-page/?district=', 
               as.character(district))

  # Get the src element associated with the supplied XPath
  html(u1) %>% 
    html_nodes(xpath=img_path) %>% 
    html_attr("src") -> src

  # All images are named "XXXX.jpg", so I extract the last 8 characters
  data_frame(id=as.character(district), 
             jpg=str_sub(src, start = -8L))
  
}) %>%  
  bind_rows %>% 
  left_join(df, img_df, by="id") -> df

lookup_code("Texas")

districts <- state_legislative_districts("48", house = "lower", detailed = FALSE)

txlege <- geo_join(districts, df, "NAME", "id")

pal <- colorFactor(c("blue", "red"), txlege$Party) # Blue for Democrats, red for Republicans

rep_url <- paste0('http://www.house.state.tx.us/members/member-page/?district=', txlege$id)

popup <- paste(sep = "<br/>", 
               paste0("<img src='http://www.house.state.tx.us/photos/members/", txlege$jpg, "' />"), 
               paste0("<b>Representative: </b>", txlege$Name), 
               paste0("<b>District: </b>", txlege$id), 
               paste0("<a href='", rep_url, "'>Link to website</a>"))

leaflet(txlege) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(Party), 
              color = "black", 
              popup = popup, 
              fillOpacity = 0.5, 
              weight = 0.5) %>%
  addLegend(position = "bottomleft",
            colors = c("blue", "red"), 
            labels = c("Democrat", "Republican"), 
            opacity = 1, 
            title = "Texas House of Representatives")
