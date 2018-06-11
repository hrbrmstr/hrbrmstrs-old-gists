library(data.table)
library(verisr)
library(dplyr)
library(statebins)

vcdb <- json2veris("/Users/bob/Desktop/r/VCDB-d3/VCDB/data/json/")
tbl_dt(vcdb) %>% 
  filter(victim.state %in% state.abb) %>% 
  group_by(victim.state) %>% 
  summarize(count=n()) %>%
  select(state=victim.state, value=count) %>%
  statebins_continuous(legend_position="bottom", legend_title="Breaches per state", 
                       brewer_pal="RdPu", text_color="black", font_size=3)



pop <- read.csv("http://www.census.gov/popest/data/state/totals/2009/tables/NST-EST2009-01.csv",
                skip=9, header=FALSE, stringsAsFactors=FALSE)[1:51,]
tbl_df(pop) %>%
  select(state=V1, value=V4) %>%
  mutate(state=gsub(".", "", state, fixed=TRUE),
         value=as.numeric(gsub(",", "", value))) %>%
  filter(state %in% state.name) %>%
  statebins_continuous(legend_position="bottom", legend_title="Population per state", 
                       brewer_pal="RdPu", text_color="black", font_size=3)

