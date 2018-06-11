library(tidyverse)
library(hrbrmisc)

ice <- read_csv("ftp://sidads.colorado.edu/DATASETS/NOAA/G02186/masie_4km_allyears_extent_sqkm.csv", skip=1)

saveRDS(ice, "masie.rds")

colnames(ice) %>%
  gsub("\\([[:digit:]]+\\) ", "", .) %>%
  gsub("yyyyddd", "year_day", .) %>%
  setNames(ice, .) %>%
  mutate(date=as.Date(as.character(year_day), format="%Y%j", origin="1970-01-01")) %>%
  select(-year_day) %>%
  gather(area, extent, -date) %>%
  mutate(area=gsub("_", " ", area),
         year=format(date, "%Y"),
         month=format(date, "%m"),
         day=format(date, "%d"),
         flat=as.Date(sprintf("2016-%s-%s", month, day)),
         alpha=ifelse(year=="2016", 1, 1/2),
         col=ifelse(year=="2016", "#9e0142", "#bababa")) -> ice


ggplot(ice) +
  geom_line(aes(date, extent, group=area, color=area), size=2/5) +
  scale_x_date(date_labels="%y") +
  scale_y_continuous(expand=c(0,0), label=scales::comma) +
  facet_wrap(~area, scales="free") +
  labs(x=NULL, y=NULL) +
  labs(x=NULL, y=NULL, title=" Daily Ice Extent by Region in Square Kilometers (2006-2016)") +
  theme_hrbrmstr_hind(grid="XY", axis="xy", strip_text_size=10, plot_margin=margin(30,30,30,30)) +
  theme(legend.position="none")

ggplot(ice) +
  geom_line(aes(flat, extent, group=year, color=col, alpha=alpha), size=2/5) +
  scale_x_date(expand=c(0,0), date_breaks="3 months", date_labels="%b") +
  scale_y_continuous(label=scales::comma) +
  scale_alpha_identity() +
  scale_color_identity() +
  facet_wrap(~area, scales="free") +
  labs(x=NULL, y=NULL, title=" Daily Ice Extent by Region in Square Kilometers (2006-2016)") +
  theme_hrbrmstr_hind(grid="XY", axis="xy", strip_text_size=10, plot_margin=margin(30,30,30,30)) +
  theme(legend.position="none")

filter(ice, area=="Central Arctic") %>%
  ggplot() +
  geom_line(aes(flat, extent, group=year, color=col, alpha=alpha), size=2/5) +
  scale_x_date(expand=c(0,0), date_breaks="1 month", date_labels="%b") +
  scale_y_continuous(expand=c(0,0), label=scales::comma) +
  scale_alpha_identity() +
  scale_color_identity() +
  labs(x=NULL, y=NULL, title="Central Arctic Daily Ice Extent in Square Kilometers (2006-2016)") +
  theme_hrbrmstr_hind(grid="XY", axis="xy", plot_margin=margin(30,30,30,30)) +
  theme(legend.position="none")




