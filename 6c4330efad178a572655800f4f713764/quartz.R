library(showtext)
library(emojifont)
library(tidyverse)

font_add_google("Roboto Condensed", "robc")

p = ggplot(NULL, aes(x = 1, y = 1)) + ylim(0.8, 1.2) +
    theme(axis.title = element_blank(), axis.ticks = element_blank(),
          axis.text = element_blank()) +
    annotate("text", 1, 1.1, family = "robc", size = 15,
             label = "Four score") +
    annotate("text", 1, 0.9, label = 'and seven years ago',
             family = "robc", fontface = "bold", size = 12)

quartz()
showtext_begin()
print(p)
showtext_end()