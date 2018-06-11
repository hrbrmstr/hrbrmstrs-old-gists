library(rvest)
library(magrittr)
library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)

# get page

pg <- html("http://www.bls.gov/opub/ted/2015/consumer-spending-by-age-group-in-2013.htm#tab-2")

# extract table

pg %>%
  html_nodes("table") %>%
  extract2(1) %>%
  html_table(header=TRUE) %>%
  rename(spending_category=`Spending category`) %>%
  filter(spending_category != "Total") %>%
  gather(age_group, value, -spending_category) %>%
  mutate(label=percent(value/100)) -> spending

# for facet ordering

spending %>%
  group_by(spending_category) %>%
  summarise(μ=mean(value)) %>%
  arrange(μ) %>% .$spending_category -> cat_levels

# plot

spending %>%
  mutate(spending_category=factor(spending_category,
                                  levels=cat_levels, ordered=TRUE)) %>%
  ggplot(aes(x=age_group, y=value)) +
  geom_bar(stat="identity", aes(fill=spending_category)) +
  geom_text(aes(y=value+5, label=label), size=2.5) +
  scale_x_discrete(expand=c(0, 0)) +
  scale_y_continuous(expand=c(0, 0), limits=c(0, max(spending$value)+10)) +
  labs(x=NULL, y=NULL, title="Consumer spending by age group in 2013\n") +
  facet_wrap(~spending_category) +
  coord_flip() +
  theme(panel.background=element_rect(fill="#f0f0f0")) +
  theme(panel.grid=element_blank()) +
  theme(panel.border=element_blank()) +
  theme(panel.margin=unit(1, "lines")) +
  theme(strip.background=element_blank()) +
  theme(strip.text=element_text(size=6.5)) +
  theme(axis.ticks=element_blank()) +
  theme(axis.text.x=element_blank()) +
  theme(legend.position="none") -> gg

# save

ggsave("bls_spending.svg", width=9, height=6)