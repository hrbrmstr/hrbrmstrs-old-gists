library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(scales)
library(gridExtra)

read_csv("ddos-akamai.csv") %>%
  gather(quarter, value, -layer, -Vector) %>%
  mutate(quarter=as.Date(quarter, format="%m/%d/%Y"),
         value=ifelse(is.na(value), 0, value)) %>%
  mutate(value=value/100) -> dat

qtr <- data.frame(d=unique(dat$quarter))

dat %>% filter(layer=="Infrastructure") -> infra
infra %>% filter(quarter==qtr$d[3]) %>% arrange(desc(value)) %>% .$Vector -> infra_vec
infra %>% mutate(Vector=factor(Vector, levels=infra_vec, ordered=TRUE)) -> infra

gg <- ggplot(infra, aes(x=quarter, y=value, group=Vector))
gg <- gg + geom_vline(data=qtr, aes(xintercept=as.numeric(d)),
                      linetype="dashed", color="#7f7f7f", alpha=3/4)
gg <- gg + geom_line(aes(color=Vector), size=1/3, alpha=3/4)
gg <- gg + scale_x_date(expand=c(0, 0), label=date_format("%Y-%b"))
gg <- gg + scale_y_continuous(label=percent)
gg <- gg + scale_color_discrete(name="Infra\nVector")
gg <- gg + labs(x=NULL, y="DDoS Attack Vector Frequency", title="DDoS attack type distribution (Infrastructure)\n")
gg <- gg + theme_bw()
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(axis.ticks.x=element_blank())
gg <- gg + theme(axis.ticks.y=element_blank())
gg <- gg + theme(plot.title=element_text(hjust=0, size=14, face="bold"))
infra_gg <- gg
infra_grob <- ggplotGrob(infra_gg)

dat %>% filter(layer!="Infrastructure") -> app
app %>% filter(quarter==qtr$d[3]) %>% arrange(desc(value)) %>% .$Vector -> app_vec
app %>% mutate(Vector=factor(Vector, levels=app_vec, ordered=TRUE)) -> app


gg <- ggplot(app, aes(x=quarter, y=value, group=Vector))
gg <- gg + geom_vline(data=qtr, aes(xintercept=as.numeric(d)),
                      linetype="dashed", color="#7f7f7f", alpha=3/4)
gg <- gg + geom_line(aes(color=Vector), size=1/3, alpha=3/4)
gg <- gg + scale_x_date(expand=c(0, 0), label=date_format("%Y-%b"))
gg <- gg + scale_y_continuous(label=percent, breaks=c(0.0, 0.05, 0.10), limits=c(0.0, 0.1))
gg <- gg + scale_color_discrete(name="App\nVector")
gg <- gg + labs(x=NULL, y="DDoS Attack Vector Frequency", title="DDoS attack type distribution (Application)\n")
gg <- gg + theme_bw()
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(axis.ticks.x=element_blank())
gg <- gg + theme(axis.ticks.y=element_blank())
gg <- gg + theme(plot.title=element_text(hjust=0, size=14, face="bold"))
gg <- gg + theme(legend.key=element_rect())
app_gg <- gg
app_grob <- ggplotGrob(app_gg)

app_grob$widths <- infra_grob$widths

grid.arrange(infra_grob, app_grob, ncol=1, heights=c(0.75, 0.25))
