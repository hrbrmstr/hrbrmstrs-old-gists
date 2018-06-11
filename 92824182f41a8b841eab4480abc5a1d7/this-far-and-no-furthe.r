library(rtweet)
library(ggalt)
library(hrbrthemes)
library(tidyverse)

me <- get_timeline("hrbrmstr", n=3000, home=TRUE)

mutate(me, `Tweet length`=map_int(text, nchar)) %>% 
  ggplot(aes(`Tweet length`)) +
  geom_bkde(aes(color="X", fill="X"), alpha=2/3) +
  geom_vline(xintercept=140, linetype="dashed", size=0.25) +
  geom_label(data=data.frame(), aes(x=140, y=0.065, label="This far and no further!"),
             size=3, fontface="italic", family=font_rc, hjust=0, vjust=1, nudge_x=2, label.size=0) +
  scale_x_comma(breaks=sort(c(140, seq(0,280,40))), limits=c(0,280)) +
  scale_y_continuous(expand=c(0,0)) +
  labs(y="Density", title="Tweet length in my timeline for the past ~24 hours",
       caption="Brought to you by #rstats, rtweet & ggalt") +
  theme_ipsum_rc(grid="XY") +
  theme(legend.position="none")
