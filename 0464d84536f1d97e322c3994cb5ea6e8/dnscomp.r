library(rvest)
library(stringi)
library(ggbeeswarm)
library(hrbrthemes)
library(tidyverse)

pg <- read_html("https://medium.com/@nykolas.z/dns-performance-comparison-google-quad9-opendns-norton-cleanbrowsing-and-yandex-d62d24e38f98")

html_nodes(pg, xpath=".//p[contains(., 'any event')]/following-sibling::blockquote[strong]") %>% 
  html_text() %>% 
  stri_match_all_regex(
    "(^([[:alpha:]]+)[[:space:][:]]+|(\\#[[:alnum::] [[:alnum:]_]+: [[:alnum:]\\.]]+ ms))"
  ) %>% 
  map(~stri_replace_all_fixed(.x[,2], ":", "")) %>% 
  map_df(~{
    stri_split_regex(.x[2:length(.x)], "[[:space:]]+", simplify = TRUE)[,2:3] %>% 
      as_data_frame() %>% 
      mutate(city = stri_trim_both(.x[1])) %>% 
      set_names(c("service", "ms", "city")) %>% 
      mutate(ms = as.numeric(ms)) %>% 
      mutate(service = stri_replace_all_fixed(service, "_", " "))
  }) -> dns_times

ggplot(dns_times, aes(service, ms)) +
  geom_quasirandom(aes(color=city)) +
  ggthemes::scale_color_tableau(name=NULL, palette = "tableau20") +
  labs(x=NULL, title="DNS Service Response Times : City") +
  theme_ipsum_rc(grid="XY")

ggplot(dns_times, aes(city, ms)) +
  geom_quasirandom(aes(color=service)) +
  ggthemes::scale_color_tableau(name=NULL) +
  facet_wrap(~city, scales="free_x", ncol=7, strip.position = "bottom") +
  labs(x=NULL, title="DNS Service Response Times : Service") +
  theme_ipsum_rc(grid="XY") +
  theme(strip.text.x=element_text(hjust=0.5)) +
  theme(axis.text.x=element_blank()) +
  theme(panel.spacing.x=unit(10, "pt")) +
  theme(legend.position="bottom")
