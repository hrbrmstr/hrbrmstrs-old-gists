library(gh)
library(crandb)
library(hrbrthemes)
library(tidyverse)

tidy_repos <- gh("/orgs/tidyverse/repos")

map_chr(tidy_repos, "name") %>% 
  discard(`%in%`, c("ggplot2-docs", "tidyverse.org", "tidytemplate", "style")) %>% 
  stringi::stri_replace_last_fixed("4", "") %>% 
  map(package, version = "all") %>% 
  map_df(~{
    vers <- map(.x$versions, "date")
    data_frame(
      pkg = .x$name,
      version = names(vers), 
      rls = lubridate::ymd_hms(vers)
    )
  }) -> pkg_df

wrap_it <- scales::wrap_format(120)

group_by(pkg_df, pkg) %>% 
  arrange(rls) %>% 
  summarise(diff = list(diff(rls))) %>% 
  unnest() %>% 
  mutate(diff = as.numeric(diff, "days")) %>% 
  ggplot(aes(diff)) +
  ggalt::geom_bkde(color="#542788", fill="#54278877") +
  scale_x_comma(breaks=seq(0, 1000, 50)) +
  labs(x="Days between releases", y="Density",
       title="Distribution of days between CRAN releases of tidyverse packages",
       subtitle=wrap_it(sprintf("Includes: %s", paste0(sort(unique(pkg_df$pkg)), collapse=", "))),
       caption="Source: GitHub API (for package names) & MetaCRAN <www.r-pkg.org> for release info") +
  theme_ipsum_rc(grid="XxYy") +
  theme(axis.text.y=element_blank())
