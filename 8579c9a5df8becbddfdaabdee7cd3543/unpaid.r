library(ggalt)
library(ggrepel)
library(hrbrthemes)
library(tidyverse)

gender <- read_csv("zGENDER_EMP_01032017184057398.csv")

glimpse(gender)

filter(gender, Indicator == "Time spent in unpaid work, by sex") %>%
  filter(AGE == "TOTAL", TIME == "LATEST") %>%
  select(Country, Sex, Value) %>%
  spread(Sex, Value) %>%
  mutate(total = Men + Women) %>%
  arrange(desc(Women)) %>%
  mutate(color = ifelse(grepl("OECD", Country), "highlight", "normal")) %>%
  mutate(Country = factor(Country, levels=rev(Country))) -> unpaid_work

update_geom_font_defaults(font_rc_light, size = 3)

ggplot(unpaid_work) +
  geom_dumbbell(aes(y=Country, x=Men, xend=Women, color = color),
                size=3, colour_x = "#5b8124", colour_xend = "#bad744",
                dot_guide=TRUE, dot_guide_size=0.15) +
  geom_text(aes(Women, Country,
                label=sprintf("%s%s", Women, c(" (Women)", rep("", nrow(unpaid_work)-1)))),
            hjust=0, nudge_x=4) +
  geom_label(aes(Men, Country,
                 label=sprintf("%s%s", c("(Men) ", rep("", nrow(unpaid_work)-1)), Men)),
             hjust=1, nudge_x=-3, label.size=0) +
  scale_x_continuous(limits=c(NA, 400)) +
  scale_color_manual(values=c(highlight="#5b5b5b", normal="#e3e2e1"), guide=FALSE) +
  labs(x=NULL, y=NULL,
       title="Unpaid Work",
       subtitle="Average minutes-per-day spent on child care and other unpaid work (15-64 year-olds).\nWomen work longer unpaid hours in every country in the OECD survey.",
       caption="Source: OCED Gender Data Portal 2016") +
  theme_ipsum(grid="") +
  theme(axis.text.x=element_blank()) -> gg

ggsave("alot1.png", gg, width = 10, height = 10, dpi = 144)


unpaid_work %>%
  mutate(diff = Women - Men) %>%
  arrange(diff) %>%
  mutate(Country = factor(Country, levels=Country)) %>%
  ggplot(aes(diff, Country)) +
  geom_lollipop(horizontal = TRUE, size = 1.5, aes(color = color), point.colour = "#5b8124") +
  geom_label(aes(label=sprintf("%s%s", diff, c(rep("", nrow(unpaid_work)-1), " more hours worked by women"))),
             label.size=0, hjust=0, nudge_x=3) +
  scale_x_continuous(expand=c(0,0), limits=c(0, 390)) +
  scale_color_manual(values=c(highlight="#5b5b5b", normal="#e3e2e1"), guide=FALSE) +
  labs(x=NULL, y=NULL,
       title="Unpaid Work (Men vs Women",
       subtitle="Bar length is the difference between the average minutes-per-day spent on child care and other unpaid work\n by men and women (15-64 year-olds). Women work longer unpaid hours in every country in the OECD survey.",
       caption="Source: OCED Gender Data Portal 2016") +
  theme_ipsum_rc(grid="X") +
  theme(axis.text.x=element_blank()) -> gg

ggsave("alot2.png", gg, width = 10, height = 10, dpi = 144)


ggplot(unpaid_work, aes(Men, Women, label=Country, fill=color, color=color)) +
  geom_label_repel(family=font_rc) +
  scale_x_continuous(limits=c(40, 200), breaks=seq(40, 180, 40),
                     labels=sprintf("%d%s", seq(40, 180, 40), c(" minutes", rep("", 3)))) +
  scale_y_continuous(limits=c(200, 400), breaks=seq(200, 400, 50),
                     labels=sprintf("%d%s", seq(200, 400, 50), c("\nminutes", rep("", 4)))) +
  scale_color_manual(values=c(highlight="white", normal="#2b2b2b"), guide=FALSE) +
  scale_fill_manual(values=c(highlight="#5b5b5b", normal="white"), guide=FALSE) +
  labs(x="Men", y="Women",
       title="Unpaid Work (Men vs Women)",
       subtitle="Average minutes-per-day spent on child care and other unpaid work (15-64 year-olds)\nWomen work longer unpaid hours in every country in the OECD survey.",
       caption="Source: OCED Gender Data Portal 2016") +
  theme_ipsum_rc() -> gg

ggsave("alot3.png", gg, width = 10, height = 10, dpi = 144)

ggplot(unpaid_work, aes(Men, Women, label=Country, color=color)) +
  geom_point(size=2) +
  scale_x_continuous(limits=c(0, 400), breaks=seq(0, 400, 100),
                     labels=sprintf("%d%s", seq(0, 400, 100), c(" minutes", rep("", 4)))) +
  scale_y_continuous(limits=c(0, 400), breaks=seq(0, 400, 100),
                     labels=sprintf("%d%s", seq(0, 400, 100), c("\nminutes", rep("", 4)))) +
  scale_color_manual(values=c(highlight="#542788", normal="#e08214"), guide=FALSE) +
  labs(x="Men", y="Women",
       title="Unpaid Work (Men vs Women)",
       subtitle="Average minutes-per-day spent on child care and other unpaid work (15-64 year-olds)\nWomen work longer unpaid hours in every country in the OECD survey.",
       caption="Source: OCED Gender Data Portal 2016") +
  theme_ipsum_rc() -> gg

ggsave("alot4.png", gg, width = 9, height = 9, dpi = 144)


