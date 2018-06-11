library(ggplot2)
library(magick)
library(hrbrthemes)
library(tidyverse)

tbl_df(read.csv(stringsAsFactors=FALSE, text='team,p1,p2,p3
MCY,1,1,5
SYD,1,2,5
NEW,1,3,7
WSW,1,4,7
ADL,1,5,7
PER,3,6,10
WEL,3,7,10
CCM,3,8,10
MVC,6,9,10
BRI,6,10,10')) %>%
  mutate(team = sprintf("%-2s %s", 1:length(team), team)) %>%
  arrange(p3) %>%
  mutate(team = factor(team, levels=rev(team))) -> xdf

green <- "#59a255"
grey <- "#7b858e"
red <- "#a31135"

gather(xdf, pos, val, -team) %>%
  arrange(pos) %>%
  mutate(pos = factor(pos, levels=c("p2", "p1", "p3"))) -> xdf_l

ggplot() +
  geom_rect(data = data.frame(), aes(xmin=-Inf, xmax=6.5),
            ymin=-Inf, ymax=Inf, fill="#e6e6e6", colour="#e6e6e6") +
  geom_segment(data =xdf, aes(x=p1, xend=p3, y=team, yend=team), size=1, colour=grey) +
  geom_point(data = xdf_l, aes(val, team, colour=pos), size=10) +
  geom_point(data = filter(xdf_l, pos == "p2"), aes(val, team, colour=pos), size=10) + # redraw the grey ones
  geom_text(data = xdf_l, aes(val, team, label=val), size=4,
            family = font_an, color="white", fontface="bold") +
  scale_colour_manual(
    name=NULL,
    values=c(p1=green, p2=grey, p3=red),
    labels=c(p2="Current Position", p1="Highest Possible Rise", p3="Lowest Possible Fall") 
  ) +
  guides(color=guide_legend(override.aes = list(shape=15, size=3))) + # get the square
  labs(
    x=NULL, y=NULL,
    title = "How much could the A-League table change?",
    subtitle="Spread of possible positions following Round 3 fixtures in 2017-18\nGrey shaded area indicates finals qualifications"
  ) +
  theme_ipsum(grid="") +
  theme(legend.position="bottom") +
  theme(legend.direction="horizontal") +
  theme(plot.title=element_text(color="#595963")) +
  theme(axis.text.x=element_blank()) +
  theme(axis.text.y=element_text(size=14, hjust=0, face="bold")) -> gg

fig <- image_graph(width=1016, height=573, res=72)
print(gg)
dev.off()

fig %>% 
  image_join(image_read("footer.png")) %>% 
  image_append(stack = TRUE) %>% 
  image_write("final.png")
