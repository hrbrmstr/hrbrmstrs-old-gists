library(hrbrthemes)
library(showtext)
library(emojifont)
library(tidyverse)

font_add_google("Roboto Condensed", "robc")

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(
    x="Weight", y="Miles Per Gallon", 
    title="Seminal ggplot2 font",
    subtitle="An insightful subtitle",
    caption="Source: hrbrthemes"
  ) +
  theme_ipsum_rc(
    grid="XY", 
    base_family = "robc", plot_title_face = "bold", subtitle_face = "plain",
    subtitle_family = "robc",
    caption_family = "robc"
  ) -> p

quartz()
showtext_begin()
print(p)
showtext_end()
