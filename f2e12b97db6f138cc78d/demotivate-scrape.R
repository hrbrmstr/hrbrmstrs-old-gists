library(rvest)
library(httr)

dem <- html_session("http://www.despair.com/demotivators.html",
                    user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.78.2 (KHTML, like Gecko) Version/7.0.6 Safari/537.78.2"))

quotes <- data.frame(category=dem %>% html_nodes(xpath="//div/a/h3") %>% html_text(), 
                     text=dem %>% html_nodes(xpath="//div[@class='tilecontents']/p") %>% html_text(),
                     image_url=dem %>% html_nodes(xpath="//img[@class='tileimg']") %>% html_attr("src"))[-1,]

head(quotes)
