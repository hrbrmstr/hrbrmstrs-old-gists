library(readxl)
library(stringi)
library(hrbrthemes)
library(tidyverse)

read_excel("~/Downloads/20090610-Samm-roadmap-chart-template.xls", sheet=2, range = "A9:I21") %>%
  janitor::clean_names() %>%
  mutate_at(vars(-security_practices_phase), as.integer) %>%
  gather(phase, value, -security_practices_phase) %>%
  rename(practice = security_practices_phase) %>%
  mutate(practice = stri_replace_last_fixed(practice, " ", "\n")) %>%
  left_join(
    data_frame(
      practice = unique(.$practice),
      fill = c("#214f69", "#214f69", "#214f69", # just too lazy to use an XLS-enabled
               "#713b26", "#713b26", "#713b26", # package that makes it possible to
               "#226d3d", "#226d3d", "#226d3d", # extract colors from the names
               "#670b20", "#670b20", "#670b20")
    ),
    by = "practice"
  ) %>%
  mutate(practice = factor(practice, levels=unique(practice))) %>%
  mutate(phase = factor(phase, levels=unique(phase))) -> xdf

data_frame(
  start = 1:length(levels(xdf$phase)),
  end = start + 1L,
  sfill = rep(c("#b2b2b255", "#00000000"), length(start)/2)
) -> stripes_df

ggplot(xdf) +
  geom_rect(
    data = stripes_df, aes(xmin=start, ymin=-Inf, xmax=end, ymax=Inf, fill=sfill)
  ) +
  geom_area(aes(as.numeric(phase), value, fill=fill), alpha=8/9) +
  geom_vline(xintercept = 1) +
  geom_hline(yintercept = 0) +
  scale_x_continuous(expand=c(0,0), position="top", limits=c(1, length(levels(xdf$phase)))) +
  scale_y_continuous(expand=c(0,0)) +
  scale_fill_identity() +
  facet_wrap(~practice, ncol=1, strip.position = "left") +
  labs(x=NULL, y=NULL) +
  theme_ipsum_rc(grid="Y") +
  theme(legend.position="false") +
  theme(axis.text.x=element_blank()) +
  theme(axis.text.y=element_blank()) +
  theme(strip.text.y=element_text(angle=180, hjust=1))