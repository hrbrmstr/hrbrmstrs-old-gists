library(rvest)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(scales)
library(directlabels)

URL <- "http://www.w3schools.com/browsers/browsers_os.asp"
pg <- read_html(URL)

tabs <- html_table(html_nodes(pg, "table"))
tabs <- bind_rows(lapply(tabs, function(x) {
  x <- mutate_each(x, funs(as.numeric(gsub("%", "", .))), -1)
  x <- mutate(x, year=colnames(x)[1])
  cn <- colnames(x)
  cn[1] <- "Month"
  colnames(x) <- cn # setNames did not work (surprisingly)
  x <- gather(x, os, pct, -year, -Month)
  x <- mutate(x, pct=pct/100)
  x <- mutate(x, month=as.Date(sprintf("%s-%s-01", year, Month), format="%Y-%B-%d"))
  select(x, -year, -Month)
}))

gg <- ggplot(filter(tabs, !os %in% c("WinNT", "Win95", "Win98", "NT*", "Win2003", "W2003")), 
             aes(x=month, y=pct))
gg <- gg + geom_smooth(aes(group=os, color=os), se=FALSE)
gg <- gg + scale_y_continuous(label=percent)
gg <- gg + labs(x=NULL, y="Market Share", title="OS Market Share Over Time\n(Reported by browser)")
gg <- gg + theme_tufte(base_family="Helvetica")
direct.label(gg, list("last.points"))

