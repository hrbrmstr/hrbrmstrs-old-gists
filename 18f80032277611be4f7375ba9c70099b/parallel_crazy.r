library(hrbrthemes) # github
library(tidyverse)

data_frame(
  `Country` = c('South Africa', 'UAE', 'Vietnam', 'Malaysia', 'Nigeria (Lagos)', 'China', 'India'),
  `Site Foreman` = c(28, 20, 10, 18, 13.95, 6, 1.7),
  `Plumber,\nElectrician` =c (7, 8, 11, 7, 2, 3, 1.2),
  `Carpenter,\nBricklayer` = c(7, 8, 9, 5, 2, 3, 1.1),
  `Tiler,\nPlasterer` = c(6, 8, 7, 7, 2, 3, 0.8),
  `General\nLabourer` = c(3, 4, 6, 3, 1.25, 2, 0.4)
) %>%
  gather(occupation, amount, -Country) %>%
  group_by(occupation) %>%
  mutate(occupation_lab = sprintf("%s\n%s", min(amount), occupation)) %>%
  ungroup() %>%
  mutate(occupation_lab = factor(occupation_lab, levels = unique(occupation_lab))) %>%
  group_by(occupation) %>%
  mutate(amt_norm = scales::rescale(amount)) -> wages

group_by(wages, occupation_lab) %>%
  summarise(amt = max(amount)) -> top_wage

last_names <- filter(wages, occupation == "General\nLabourer")

update_geom_font_defaults(size=3)

ggplot() +
  geom_line(data=wages,
            aes(x=occupation_lab, y=amt_norm, group=Country, linetype=Country, color=Country)) +
  geom_label(data=top_wage, aes(occupation_lab, y=1.1, label=amt), label.size=0, label.padding = unit(0.5, "lines")) +
  geom_text(data=last_names, aes(x=5.05, y=amt_norm, label=Country, color=Country), hjust=0,
            nudge_y=c(-0.03, 0, 0, 0.03, 0, 0, 0)) +
  scale_x_discrete(
    expand=c(0,0.05),
    breaks=c(as.character(unique(wages$occupation_lab))),
    limits=c(as.character(unique(wages$occupation_lab)), " ")
  ) +
  scale_linetype_manual(
    values = c(`South Africa`="1211", `UAE`="1121", `Vietnam`="1112",
               `Malaysia`="1311",  `Nigeria (Lagos)`="solid", `China`="1131",
               `India`="1113")
  ) +
  scale_color_manual(
    values = c(`South Africa`="#737373", `UAE`="#737373", `Vietnam`="#737373",
               `Malaysia`="#737373",  `Nigeria (Lagos)`="#ef6548", `China`="#737373",
               `India`="#737373")
  ) +
  labs(x=NULL, y=NULL,
       title="Labor costs in Nigeria are generally among the lowest",
       subtitle="Hourly wage levels in the construction sector (USD in 2012)",
       caption="Source: <https://www.chezvoila.com/blog/parallel>") +
  theme_ipsum(grid="X") +
  theme(axis.text.y=element_blank()) +
  theme(legend.position="none") +
  theme(plot.caption=element_text(hjust=0))
