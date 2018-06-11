library(hrbrthemes)
library(rvest)
library(tidyverse)

list(
  Obama="http://m.rasmussenreports.com/public_content/politics/obama_administration/obama_approval_index_history",
  Trump="http://m.rasmussenreports.com/public_content/politics/trump_administration/trump_approval_index_history"
) %>%
  map_df(~{
    read_html(.x) %>%
      html_table() %>%
      .[[1]] %>%
      tbl_df() %>%
      select(date=Date, approve=`Total Approve`, disapprove=`Total Disapprove`)
  }, .id="who") -> ratings

mutate_at(ratings, c("approve", "disapprove"), function(x) as.numeric(gsub("%", "", x, fixed=TRUE))/100) %>%
  mutate(date = lubridate::dmy(date)) %>%
  filter(!is.na(approve)) %>%
  group_by(who) %>%
  arrange(date) %>%
  mutate(dnum = 1:n()) %>%
  ungroup() %>%
  ggplot(aes(dnum, approve, color=who)) +
  geom_hline(yintercept = 0.5, size=0.5) +
  geom_point(size=0.25) +
  scale_y_percent(limits=c(0,1)) +
  scale_color_manual(name=NULL, values=c("Obama"="#313695", "Trump"="#a50026")) +
  labs(x="Day in office", y="Approval Rating",
       title="Presidential approval ratings from day 1 in office",
       subtitle="For fairness, data was taken solely from Trump's favorite polling site (Rasmussen)",
       caption="Data Source: <rasmussenreports.com>\nCode: <https://gist.github.com/hrbrmstr/a7310e1b64d0797401d01d0c6195bd8b>") +
  theme_ipsum_rc(grid="XY", base_size = 16) +
  theme(legend.direction = "horizontal") +
  theme(legend.position=c(0.8, 1.05))