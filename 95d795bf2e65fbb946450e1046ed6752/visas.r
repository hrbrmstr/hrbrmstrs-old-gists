library(tabulizer)
library(hrbrmisc)
library(ggalt)
library(stringi)
library(tidyverse)

URL <- "https://travel.state.gov/content/dam/visas/Statistics/AnnualReports/FY2016AnnualReport/FY16AnnualReport-TableIII.pdf"
fil <- sprintf("data/%s", basename(URL))
if (!file.exists(fil)) download.file(URL, fil)

tabs <- tabulizer::extract_tables("~/data/FY16AnnualReport-TableIII.pdf")

bind_rows(
  tbl_df(tabs[[1]][-1,]),
  tbl_df(tabs[[2]][-c(12,13),]),
  tbl_df(tabs[[3]][-c(7, 10:11), -2]),
  tbl_df(tabs[[4]][-21,]),
  tbl_df(tabs[[5]]),
  tbl_df(tabs[[6]][-c(6:7, 30:32),]),
  tbl_df(tabs[[7]][-c(11:12, 25:27),])
) %>% 
  setNames(c("foreign_state", "immediate_relatives",  "special_mmigrants", 
             "family_preference", "employment_preference", "diversity_immigrants", 
             "total")) %>% 
  mutate_each(funs(make_numeric), -foreign_state) %>% 
  mutate(foreign_state=trimws(foreign_state)) %>% 
  filter(foreign_state %in% c("Iran", "Iraq", "Libya", "Somalia", "Sudan", "Syria", "Yemen")) %>% 
  gather(preference, value, -foreign_state) %>% 
  mutate(preference=stri_replace_all_fixed(preference, "_", " " )) %>% 
  mutate(preference=stri_trans_totitle(preference)) %>% 
  ggplot(aes(value, foreign_state)) +
  geom_lollipop(horizontal=TRUE) +
  scale_x_continuous(expand=c(0,0), label=scales::comma) +
  facet_wrap(~preference, scales="free") +
  labs(x="# Visas", y=NULL) +
  theme_hrbrmstr_msc(grid="X")
