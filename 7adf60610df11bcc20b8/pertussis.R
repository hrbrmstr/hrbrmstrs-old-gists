library(rvest)
library(dplyr)
library(magrittr)
library(ggplot2)
library(scales)
library(gridExtra)

# get pertussis data
#
pg <- html("http://www.cdc.gov/pertussis/surv-reporting/cases-by-year.html")
pg %>%
  html_nodes("table") %>%
  html_table(header=TRUE) %>%
  extract2(1) %>%
  rename(year=Year, cases=`No. Reported Pertussis Cases`) %>%
  mutate(cases=as.numeric(gsub("\\*", "", cases))) -> pertussis

# plot raw #'s

gg <- ggplot(pertussis, aes(x=year, y=cases, group=1)) -> gg
gg <- gg + geom_line()
gg <- gg + theme_bw()
gg <- gg + scale_x_continuous(expand=c(0,0), breaks=seq(1920, 2014, 10))
gg <- gg + scale_y_continuous(expand=c(0,0), label=comma)
gg <- gg + labs(x=NULL, y="# Cases", title="Pertussis (Whooping Cough) Cases Since 1922\n")
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(axis.line=element_line(color="#b3b3b3"))
gg <- gg + theme(plot.title=element_text(hjust=0))
gg1 <- gg

# get US population

pg <- html("http://www.multpl.com/united-states-population/table")
pg %>%
  html_nodes("table") %>%
  html_table(header=TRUE) %>%
  extract2(1) %>%
  rename(year=Date, pop=`US Population\n          Value`) %>%
  mutate(year=as.numeric(substr(year, 8, 12)),
         pop=as.numeric(gsub(" million", "", pop))*1000000) %>%
  distinct(year) -> population

# calculate and show rate per 100K

pertussis %>%
  left_join(population) %>%
  mutate(per=(cases/pop)*100000) -> fract

# plot rate by 100K

gg <- ggplot(fract, aes(x=year, y=per, group=1)) -> gg
gg <- gg + geom_line()
gg <- gg + theme_bw()
gg <- gg + scale_x_continuous(expand=c(0,0), breaks=seq(1920, 2014, 10))
gg <- gg + scale_y_continuous(expand=c(0,0), label=comma)
gg <- gg + labs(x=NULL, y="# Cases per 100K",
                title="Pertussis (Whooping Cough) Cases (Per 100K U.S. Population) Since 1922\n")
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(axis.line=element_line(color="#b3b3b3"))
gg <- gg + theme(plot.title=element_text(hjust=0))
gg2 <- gg

grid.arrange(gg1, gg2, ncol=2)
