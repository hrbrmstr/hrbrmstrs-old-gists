library(RSelenium)
library(xml2)
library(rvest)
library(stringr)
library(dplyr)

checkForServer() # i start my own on the command line
remDr <- remoteDriver$new()
remDr$open()
remDr$navigate("http://www.gapminder.org/data/")
popup <- remDr$findElement(using="xpath", "//div[@id='indicators-table_length']/select/option[@value='-1']")
popup$clickElement()
tab <- remDr$findElements(value="//table[@id='indicators-table']")
tabs <- sapply(tab, function(x) x$getElementAttribute("outerHTML"))

pg <- read_html(tabs[[1]])

indicator <- html_text(html_nodes(pg, xpath='//*[@id="indicators-table"]/tbody/tr/td[1]'))
provider <- html_text(html_nodes(pg, xpath='//*[@id="indicators-table"]/tbody/tr/td[2]'))
category <- html_text(html_nodes(pg, xpath='//*[@id="indicators-table"]/tbody/tr/td[3]'))
subcategory <- html_text(html_nodes(pg, xpath='//*[@id="indicators-table"]/tbody/tr/td[4]'))

# this gets the XLS links and turns them to CSV links
link <- html_attr(html_nodes(pg, xpath='//*[@id="indicators-table"]/tbody/tr/td[5]/a[1]'), "href")
link <- str_replace(links, "xls$", "csv")

gap_data <- data_frame(indicator, provider, category, subcategory, link)

dput(gap_data, file="/tmp/gapdata.txt")
