library(XML)
library(httr)
library(rvest)
library(magrittr)

# setup connection & grab HTML the "old" way w/httr
freak_html <- htmlParse(content(GET("http://torrentfreak.com/top-10-most-pirated-movies-of-the-week-130304/"), as="text"))

# do the same the rvest way, using "html_session" since we may need connection info in some scripts
freak <- html_session("http://torrentfreak.com/top-10-most-pirated-movies-of-the-week-130304/")

# extracting the "old" way with xpathSApply
xpathSApply(freak_html, "//*/td[3]", xmlValue)[1:10]
xpathSApply(freak_html, "//*/td[1]", xmlValue)[2:11]
xpathSApply(freak_html, "//*/td[4]", xmlValue)
xpathSApply(freak_html, "//*/td[4]/a[contains(@href,'imdb')]", xmlAttrs, "href")

# extracting with rvest + XPath
freak %>% html_nodes(xpath="//*/td[3]") %>% html_text() %>% .[1:10]
freak %>% html_nodes(xpath="//*/td[1]") %>% html_text() %>% .[2:11]
freak %>% html_nodes(xpath="//*/td[4]") %>% html_text() %>% .[1:10]
freak %>% html_nodes(xpath="//*/td[4]/a[contains(@href,'imdb')]") %>% html_attr("href") %>% .[1:10]

# extracting with rvest + CSS selectors
freak %>% html_nodes("td:nth-child(3)") %>% html_text() %>% .[1:10]
freak %>% html_nodes("td:nth-child(1)") %>% html_text() %>% .[2:11]
freak %>% html_nodes("td:nth-child(4)") %>% html_text() %>% .[1:10]
freak %>% html_nodes("td:nth-child(4) a[href*='imdb']") %>% html_attr("href") %>% .[1:10]

# building a data frame
data.frame(movie=freak %>% html_nodes("td:nth-child(3)") %>% html_text() %>% .[1:10],
           rank=freak %>% html_nodes("td:nth-child(1)") %>% html_text() %>% .[2:11],
           rating=freak %>% html_nodes("td:nth-child(4)") %>% html_text() %>% .[1:10],
           imdb.url=freak %>% html_nodes("td:nth-child(4) a[href*='imdb']") %>% html_attr("href") %>% .[1:10],
           stringsAsFactors=FALSE)

