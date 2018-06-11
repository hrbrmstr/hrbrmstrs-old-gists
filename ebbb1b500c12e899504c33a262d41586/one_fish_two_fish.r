tt %>% 
  mutate(
    laststation = as.character(laststation),
    TagID = as.character(TagID)
  ) %>% 
  group_by(laststation) %>% 
  ggplot(aes(TagID, kmday)) +
  geom_segment(aes(xend=TagID, yend=0)) +
  geom_point(shape="—", size=5) +
  facet_wrap(~laststation, nrow=1, scales="free_x") +
  theme_ipsum_rc(grid="Y") +
  theme(strip.text=element_text(hjust=0.5)) +
  theme(panel.spacing.x=unit(0, "lines"))


