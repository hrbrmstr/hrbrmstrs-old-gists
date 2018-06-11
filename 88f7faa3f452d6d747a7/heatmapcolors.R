library(dplyr)
library(scales)
library(ggplot2)
library(RColorBrewer)

dat_sum <- dat %>% 
  mutate(A=factor(A), 
         B=factor(B)) %>%
  group_by(B, A, Outcome) %>%
  summarise(outcome_total=n()) %>%
  mutate(freq=outcome_total/sum(outcome_total)) %>%
  merge(expand(., B, A, Outcome), all.y=TRUE) %>%
  mutate(outcome_total=ifelse(is.na(outcome_total), 0, outcome_total),
         freq=ifelse(is.na(freq), 0, freq),
         fill_col=cut(freq, 
                      breaks=seq(0,1,.1),
                      include.lowest=TRUE))

dat_sum %>%
  ggplot(aes(x=B, y=A)) +  
  geom_tile(aes(fill=fill_col), color="#7f7f7f") +
  geom_text(aes(label=percent(freq), color=fill_col)) +
  scale_fill_manual(values=c("white", brewer.pal(n=9, name="BuGn"))) +
  scale_color_manual(values=c(rep("black", 6), rep("white", 3))) +
  facet_wrap(~Outcome, ncol=3) +
  theme_bw() +
  theme(legend.position="none") +
  theme(panel.grid=element_blank()) +
  theme(strip.background=element_blank())