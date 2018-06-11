library(xml2)
library(ggalt)
library(hrbrmisc)
library(tidyverse)

# go to the URL in the caption and generate the complete report and download as Excel; I'll have a blog post with the data too

read_excel("MX - Arrivals by Nationality and Religion.xls", skip=16, col_names=FALSE) %>% 
  setNames(c("religion", "nationality", sprintf("y%s", 2002:2017))) %>% 
  gather(year, ct, starts_with("y")) %>% 
  mutate(year=as.Date(sprintf("%s-01-01", sub("^y", "", year)))) %>% 
  filter(is.na(nationality)) %>% 
  select(-nationality) %>%  
  filter(religion != "Total", year != as.Date("2017-01-01")) -> refugees

include <- unique(filter(refugees, ct>500)$religion)

filter(refugees, religion %in% include) %>% 
  group_by(religion) %>% 
  summarise(mean=mean(ct)) %>% 
  arrange(desc(mean)) -> ordr

mutate(refugees, religion=factor(religion, levels=ordr$religion)) %>% 
  filter(!is.na(religion)) %>% 
  filter(religion != "Unknown") %>% 
  ggplot(aes(year, ct)) +
  geom_lollipop() +
  scale_y_continuous(label=scales::comma) +
  facet_wrap(~religion) +
  labs(x=NULL, y="Refugee count", title="Refugees admitted to the U.S. by religion; 2002-2016",
       subtitle="NOTE: Religions without at least one in-year count of 500 were excluded for brevity",
       caption="Source: U.S. State Department Refugee Processing Center <http://ireports.wrapsnet.org/Interactive-Reporting/EnumType>") +
  theme_hrbrmstr_msc(grid="Y")
  