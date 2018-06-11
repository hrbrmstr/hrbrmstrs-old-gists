library(rvest)
library(dplyr)
library(ggplot2)

url <- "http://www.bloomberg.com/visual-data/best-and-worst//most-registered-guns-per-capita-states"

pg <- html(url)

tab <- pg %>% html_nodes("table")

dat <- html_table(tab[[1]], header=TRUE)

dat %>%
  mutate(State=gsub("\\n.*$", "", State)) %>%
  select(state=2, guns_per_1k=3,
         firearm_count=4, pop_2013=5) %>%
  mutate(firearm_count=as.numeric(gsub(",", "", firearm_count)),
         pop_2013=as.numeric(gsub(",", "", pop_2013))) -> dat


gg <- ggplot(dat, aes(x=reorder(state, guns_per_1k), y=guns_per_1k))
gg <- gg + geom_bar(stat="identity")
gg <- gg + scale_y_continuous(expand=c(0,0))
gg <- gg + coord_flip()
gg <- gg + labs(x=NULL, y="Guns per 1,000 residents")
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg
