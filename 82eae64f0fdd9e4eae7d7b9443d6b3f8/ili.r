library(ggalt)
library(cdcfluview)
library(hrbrthemes)
library(tidyverse)

ili <- ilinet("national", years = 2013:2018)

update_geom_font_defaults(font_rc)
theme_set(theme_ipsum_rc(grid="XY", strip_text_face = "bold"))

select(ili, week_start, starts_with("age")) %>% 
  select(-age_25_64) %>% 
  gather(group, ct, -week_start) %>% 
  mutate(group = factor(group, levels=c("age_0_4", "age_5_24", "age_25_49", "age_50_64", "age_65"),
                        labels=c("Ages 0-4", "Ages 5-24", "Ages 25-49", "Ages 50-64", "Age 65+"))) %>% 
  ggplot(aes(week_start, ct, group=group)) +
  stat_xspline(geom="area", aes(color=group, fill=group), size=2/5, alpha=2/3) +
  scale_x_date(expand=c(0,0), date_labels="%b\n`%y") +
  scale_y_comma() +
  scale_color_ipsum() +
  scale_fill_ipsum() +
  labs(x=NULL, y="(weekly)\n# Patients Reported",
       title="Weekly reported Influenza-Like Illness (ILI) — U.S./National by Age Group",
       subtitle="All age groups except 5-24 are reporting larger number of cases this season than the previous four seasons",
       caption="Flu Seasons 2013-14 / 2014-15 / 2015-16 / 2016-17 / 2017-18\nSource: CDC/#rstats cdcfluview"
  ) +
  facet_wrap(~group, scales="free_x", nrow=1) +
  theme(axis.text.x=element_text(size=9)) +
  theme(legend.position="none")