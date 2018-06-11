library(rgeos)
library(maptools)
library(ggplot2)
library(readr)
library(dplyr)
library(tidyr)
library(scales)
library(viridis)
library(statebins)

senate <- read_csv("~/Desktop/senate.csv")

state_trans <- tolower(state.name)
names(state_trans) <- state.abb

senate <- mutate(senate, region=state_trans[State])

for (i in 103:114) {
  dat <- filter(senate, congress==i)
  dat <- summarise(group_by(dat, State), avg=mean(Score))
  plot(statebins(dat,
            state_col="State",
            value_col="avg",
            text_color="black",
            font_size=3,
            legend_title = "Luger Index",
            legend_position="bottom"))
}
