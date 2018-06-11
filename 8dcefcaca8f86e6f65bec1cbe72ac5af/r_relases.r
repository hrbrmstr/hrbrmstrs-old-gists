library(rvest)
library(tidyverse)
library(ggbeeswarm)
library(hrbrmisc)
library(ggalt)
library(gridExtra)

sprintf("http://cran.rstudio.org/src/base/R-%d", 0:3) %>% 
  map(read_html) %>% 
  map(html_table) %>% 
  map(1) %>% 
  bind_rows() %>% 
  select(version=Name, last_mod=`Last modified`) %>% 
  filter(grepl("R-", version)) %>% 
  mutate(last_mod=as.Date(anytime::anytime(last_mod)),
         mon=factor(format(last_mod, "%b"), levels=month.abb),
         day=as.numeric(format(last_mod, "%d"))) -> r_releases

ggplot(r_releases, aes(mon, day, group=mon)) +
  geom_boxplot(varwidth=TRUE, width=0.5, color="#2b2b2b66") +
  geom_quasirandom(aes(color=mon)) +
  scale_x_discrete(expand=c(0,0.45)) +
  scale_y_continuous(expand=c(0,0), limits=c(0.5,31.5), breaks=c(1, 7, 15, 21, 30)) +
  ggthemes::scale_color_tableau("tableau20", guide=FALSE) +
  labs(x=NULL,  y="day", title="R releases by month/day",
       subtitle="In-month release distribution") +
  theme_hrbrmstr_msc(grid="X") +
  theme(plot.margin=margin(l=30, r=30, t=30, b=8)) +
  theme(panel.spacing.y=unit(0, "lines")) -> r_box

count(r_releases, mon) %>% 
  ggplot(aes(mon, n)) +
  geom_lollipop(aes(color=mon), size=1) +
  scale_x_discrete(expand=c(0,0.45)) +
  scale_y_continuous(expand=c(0,0), breaks=c(0, 10, 20), limits=c(0,25)) +
  ggthemes::scale_color_tableau("tableau20", guide=FALSE) +
  labs(x=NULL, y="release count", subtitle="Number of releases in month") +
  theme_hrbrmstr_msc(grid="Y", axis="x") +
  theme(plot.margin=margin(l=31, r=31, t=8, b=30)) +
  theme(panel.spacing.y=unit(0, "lines")) -> r_ct

grid.arrange(r_box, r_ct, ncol=1, heights=unit(c(300, 150), "points"))

