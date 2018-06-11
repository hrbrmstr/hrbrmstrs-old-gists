library(dplyr)
library(ggplot2)
library(scales)

health <- read.csv("zhealth.csv", stringsAsFactors=FALSE, 
                   header=FALSE, col.names=c("pct", "area_id"))

areas <- read.csv("zarea_trans.csv", stringsAsFactors=FALSE, header=TRUE)

health %>% 
  mutate(area_id=trunc(area_id)) %>% 
  arrange(area_id, pct) %>% 
  mutate(year=rep(c("2014", "2013"), 26),
         pct=pct/100) %>% 
  left_join(areas, "area_id") %>% 
  mutate(area_name=factor(area_name, levels=unique(area_name))) %>% 
  mutate(color=rep(c("#0e668b", "#a3c4dc"), 26),
         line_col="#a3c4dc") -> health

health[health$area_name=="All Metro Areas",]$color <- c("#bc1f31", "#e5b9a5")
health[health$area_name=="All Metro Areas",]$line_col <- "#e5b9a5"

gg <- ggplot(health)
gg <- gg + geom_path(aes(x=pct, y=area_name, group=area_id, color=line_col), size=0.75)
gg <- gg + geom_point(aes(x=pct, y=area_name, color=color), size=2.25)
gg <- gg + scale_color_identity()
gg <- gg + scale_x_continuous(label=percent)
gg <- gg + labs(x=NULL, y=NULL)
gg <- gg + theme_bw()
gg <- gg + theme(plot.background=element_rect(fill="#f7f7f7"))
gg <- gg + theme(panel.background=element_rect(fill="#f7f7f7"))
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(panel.grid.major.y=element_blank())
gg <- gg + theme(panel.grid.major.x=element_line())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(legend.position="top")
gg <- gg + theme(panel.border=element_blank())
gg
