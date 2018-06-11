library(waffle)
library(hrbrthemes)
library(stringi)
library(tidyverse)

dots <- c(28, 27, 24, 20, 18, 17, 16, 16, 15)
labs <- c(
  "Support health-related cause",
  "Comment on others' health experiences",
  "Post about health experiences",
  "Join health forum or community",
  "Track and share health symptoms/behavior",
  "Post reviews of doctors",
  "Post reviews of medications/treatments",
  "Share health-related videos/images",
  "Post reviews of health insurers"
) 

labs <- map_chr(labs, ~paste0(stri_trim(stri_wrap(.x, 16)), collapse="\n"))

map2(dots, labs, ~{
  c(rep("a", .x), rep("b", 100-.x)) %>% 
    matrix(nrow = 10, ncol = 10, TRUE) %>% 
    reshape2::melt() %>% 
    setNames(c("y", "x", "val")) %>% 
    as_data_frame() %>% 
    mutate(lab = .y)
}) %>% 
  bind_rows() -> xdf

ggplot(xdf, aes(x, y, fill=val, group=lab)) +
  geom_tile(color="white", size=0.25) +
  scale_y_reverse() +
  scale_fill_manual(values=c(a="#b2182b", b="#e0e0e0")) +
  coord_equal() +
  facet_wrap(~lab, ncol=9) +
  labs(x=NULL, y=NULL) +
  theme_ipsum_rc(grid="") +
  theme(panel.spacing.x = unit(0.1, "lines")) +
  theme(legend.position="none") +
  theme(strip.text=element_text(hjust=0.5, size=10, face="bold")) +
  theme(axis.text=element_blank())
