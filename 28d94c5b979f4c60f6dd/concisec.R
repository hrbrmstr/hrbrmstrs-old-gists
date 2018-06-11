library(rvest)
library(stringr)
library(dplyr)
library(readr)

extract <- function(doc, x) {
  doc %>%
    str_match_all(x) %>%
    lapply(function(y) {
    if (length(y)==0) {
      NA
    } else {
      y[1,2]
    }
  }) %>% unlist %>% str_trim
}

pg <- html("http://www.concise-courses.com/security/conferences-of-2015/")

# Get all the paragraphs that have the semi-structured conf deets

event_text <- pg %>%
  html_nodes(xpath="//p[contains(., 'Date:')]") %>% 
  html_text

date <- event_text %>% 
  extract("Date:([[:alnum:][:punct:] ]+ 2015)\n") 

title <- event_text %>% 
  extract("Conference Title:([[:alnum:][:punct:] \t]+)\n")

where <- event_text %>% 
  extract("Where:([[:alnum:][:punct:] \t]+)Link")

# from the original HTML, get all conf links

event_link <- pg %>% 
  html_nodes(xpath="//a[@onclick][text()='Link To Event']") %>%
  html_attr("href") %>%
  str_trim

# build data frame - don't add link as it's not perfectly extracted all the time

dat <- data_frame(date, title, where)

write_csv(dat, "~/concise.csv")