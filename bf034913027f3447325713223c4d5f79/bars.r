library(hrbrthemes)
library(tidyverse)

read.csv(text="Gender,A,Ap,B,Bp
Male,6,60,15,60
Female,4,40,10,40
", header=TRUE, stringsAsFactors=FALSE) %>%
  tbl_df() -> gender

read.csv(text='Age,A,Ap,B,Bp
"Under 20",0,0,2,8
"20-29",5,50,5,20
"30-39",1,10,2,8
"40-49",3,30,5,20
"50-59",1,10,8,32
"60-69",0,0,3,12
', header=TRUE, stringsAsFactors=FALSE) %>%
  tbl_df() -> age

select(age, -Ap, -Bp) %>%
  mutate(Age = factor(Age, levels=Age)) %>%
  gather(group, ct, -Age) %>%
  mutate(group = sprintf("Group %s (N=%s)", group, c("A"=10, "B"=20)[group])) %>%
  group_by(group) %>%
  mutate(pct = ct/sum(ct)) %>%
  mutate(pct_lab = sprintf("%s (%s)", ct, scales::percent(pct))) %>%
  ggplot(aes(pct, Age)) +
  geom_segment(aes(xend=0, yend=Age, color=group), size=4, show.legend=FALSE) +
  facet_wrap(~group, ncol=1, scales="free", drop=FALSE) +
  scale_x_percent(expand=c(0,0), name=NULL) +
  scale_y_discrete(name=NULL) +
  ggthemes::scale_color_tableau() +
  theme_ipsum_rc(grid="X", axis="y", axis_text_size = 9)
