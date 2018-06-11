library(xml2) # github version
library(dplyr) 

# setup feed https://gh-rss.herokuapp.com/

feed <- read_xml("https://gh-rss.herokuapp.com/hrbrmstr.xml")
ns <- xml_ns_rename(xml_ns(feed), d1 = "feed")

data_frame(
  who = feed %>% xml_find_all("//feed:entry/feed:author/feed:name", ns) %>% xml_text,
  updated = feed %>% xml_find_all("//feed:entry/feed:updated", ns) %>% xml_text,
  link = feed %>% xml_find_all("//feed:entry/feed:link", ns) %>% xml_attr("href")
)

