library(stringi)
library(microbenchmark)
library(ggplot2)
library(readr)

ex <- "example.txt"
mb <- microbenchmark(readLines=readLines(ex),
                     read_lines=read_lines(ex),
                     stri_read_lines=stri_read_lines(ex))

autoplot(mb) +
  aes(fill="steelblue") +
  scale_y_continuous(breaks=c(0, 25, 50, 75, 100, 125, 150)) +
  scale_fill_manual(values="steelblue") +
  labs(y="Time [ms]", title="microbenchmark: readLines() vs read_lines() vs stri_read_lines() (10K line file)") +
  ggthemes::theme_tufte(base_family="Helvetica") +
  theme(legend.position="none") +
  theme(axis.ticks=element_blank()) +
  theme(panel.grid=element_line("#2b2b2b", size=0.15)) +
  theme(panel.grid.minor=element_blank()) +
  theme(plot.title=element_text(hjust=0)) +
  theme(axis.title.x=element_text(hjust=1, size=6))
