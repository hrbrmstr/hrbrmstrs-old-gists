library(tidyverse)
library(ggalt) # devtools::install_github("hrbrmstr/ggalt")

df <- data_frame(
  benchmark=c(0.52, 0.57, 0.60, 0.63, 0.64, 0.67),
  referrals=c(4.2, 4.5, 4, 4.5, 3.9, 3.6),
  year=c(2011, 2012, 2013, 2014, 2015, 2016)
)

# as of 2016-11-07 ggplot2 geom_label() seems to be ignoring the "angle" parameter, hence the non-ideal use of geom_text()

ggplot(df, aes(benchmark, referrals)) +
  geom_xspline(size=2, color="steelblue") +
  geom_point(size=4, color="steelblue") +
  geom_label(aes(label=year), label.size=0,
             nudge_x=c(0, 0, 0, 0, 0.005, 0.0075),
             nudge_y=c(-0.1, 0.1, -0.1, 0.1, 0.1, 0)) +
  geom_text(data=data_frame(), angle=15, hjust=0, family="Hind Medium", size=4.5, color="#2b2b2b", lineheight=0.9,
            aes(x=0.52, y=4.4, label="In year 1, academic\nprogress increased but\nso did behavior issues")) +
  scale_x_continuous(expand=c(0,0), labels=scales::percent, limits=c(0.5, 0.7)) +
  scale_y_continuous(expand=c(0,0), limits=c(3, 5)) +
  labs(x="% of student at or above benchmark", 
       y="# of referrals per 1,000 students per day",
       title="Participating schools improved students' academic\nperformance and reduced behavioral referrals") +
  hrbrmisc::theme_hrbrmstr(grid="XY") +
  theme(panel.border=element_rect(color="#b2b2b2", fill=NA)) +
  theme(axis.text.x=element_text(hjust=c(0, 0.5, 0.5, 0.5, 1))) +
  theme(axis.text.y=element_text(vjust=c(0, 0.5, 0.5, 0.5, 1)))