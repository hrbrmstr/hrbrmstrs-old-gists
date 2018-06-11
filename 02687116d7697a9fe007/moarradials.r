library(dplyr)
library(readr)
library(stringr)
library(lubridate)
library(ggplot2)
library(viridis)
library(scales)

#' an homage to http://jkunst.com/r/how-to-weather-radials/

#' save bandwidth

URL <- "http://bl.ocks.org/bricedev/raw/458a01917183d98dff3c/sf.csv"
fil <- basename(URL)
if (!file.exists(fil)) download.file(URL, fil)

df <- read_csv(fil)

#' saner column names

names(df) <- names(df) %>%
  str_to_lower() %>%
  str_replace("\\s+", "_")

#' date, time & month
mutate(df, id=seq(nrow(df)),
       date2=as.Date(ymd(date)),
       tmstmp=as.numeric(as.POSIXct(date2))*1000,
       month=month(ymd(date))) -> df

temp_labs <- data_frame(x=c(rep(as.Date("2014-01-01"), 3),
                            rep(as.Date("2014-07-01"), 3)),
                        y=rep(seq(0, 40, by=20), 2),
                        angle=rep(0, 6),
                        label=sprintf("%d°C", y))

gg <- ggplot()
gg <- gg + geom_label(data=temp_labs, aes(x=x, y=y, label=label),
                      color="#b2b2b2", size=2.5, label.size=0)
gg <- gg + geom_linerange(data=df,
                          aes(x=date2, ymin=min_temperaturec,
                              ymax=max_temperaturec,
                              color=mean_temperaturec),
                          size=0.75, alpha=1)
gg <- gg + scale_y_continuous(expand=c(0,0), limits=c(-20, 50),
                              breaks=seq(-20, 50, by=10),
                              labels=seq(-20, 50, by=10))
gg <- gg + scale_color_viridis(NULL, option = "A")
gg <- gg + scale_x_date(labels = date_format("%b"), breaks = date_breaks("month"))
gg <- gg + labs(x=NULL, y=NULL, title=NULL, subtitle=NULL)
gg <- gg + coord_polar()
gg <- gg + theme(panel.grid.major=element_line())
gg <- gg + theme(panel.grid.major.x=element_blank())
gg <- gg + theme(panel.grid.major.y=element_line(color=c(rep("#b2b2b2", 8), "white"), size=0.2))
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(panel.grid.minor.x=element_blank())
gg <- gg + theme(panel.grid.minor.y=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(panel.background=element_blank())
gg <- gg + theme(axis.text.x=element_text(color="#b2b2b2",angle=-seq(0, 360, 30)))
gg <- gg + theme(axis.text.y=element_blank())
gg <- gg + theme(axis.ticks.x=element_line(color="#b2b2b2", size=10))
gg <- gg + theme(axis.ticks.y=element_blank())
gg <- gg + theme(legend.position="none")

suppressWarnings(print(gg))
