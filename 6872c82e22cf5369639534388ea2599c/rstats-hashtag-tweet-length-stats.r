library(rtweet)
library(ggalt)
library(hrbrthemes)
library(tidyverse)

rstats <- search_tweets("#rstats", 3000)

# Since you are obesessing on reproducibility, you can narrow down the 
# date range to this if you run it, but the longer you wait the less 
# likely you can retrieve older tweets
range(rstats$created_at)
## [1] "2017-11-09 08:04:20 UTC" "2017-11-13 20:03:37 UTC"

mutate(rstats, `Tweet length`=map_int(text, nchar)) %>% 
  ggplot(aes(`Tweet length`)) +
  geom_bkde(aes(color="X", fill="X"), alpha=2/3) +
  geom_vline(xintercept=140, linetype="dashed", size=0.25) +
  geom_label(data=data.frame(), aes(x=140, y=Inf, label="This far and no further!"),
             size=3, fontface="italic", family=font_rc, hjust=0, vjust=1, nudge_x=2, label.size=0) +
  scale_x_comma(breaks=sort(c(140, seq(0,280,40))), limits=c(0,280)) +
  scale_y_continuous(expand=c(0,0)) +
  labs(y="Density", title=sprintf("Tweet length in #rstats over the past %s days", 
                                  round(diff(range(rstats$created_at)), 3)),
       caption="Brought to you by #rstats, rtweet & ggalt") +
  theme_ipsum_rc(grid="XY") +
  theme(legend.position="none")
