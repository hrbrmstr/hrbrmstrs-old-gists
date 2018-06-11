#' ---
#' title: ""
#' author: ""
#' date: ""
#' output:
#'   html_document:
#'     keep_md: true
#'     theme: simplex
#'     highlight: monochrome
#' ---
#+ init, include=FALSE
knitr::opts_chunk$set(message = FALSE, warning = FALSE, dev="png",
                      fig.retina = 2, fig.width = 10, fig.height = 6)

#+ libs
library(AnomalyDetection) # devtools::install_github("hrbrmstr/AnomalyDetection")
library(hrbrthemes)
library(tidyverse)

#+ data
set.seed(0)

data_frame(
  ts = seq(
    as.POSIXct("2018-04-20 00:00:00", tz="UTC"),
    as.POSIXct("2018-04-25 00:00:00", tz="UTC"),
    "1 hour"
  ),
  conns = log(sample(100000, length(ts), replace=TRUE)) # fake some anomalies
) -> conn_df


#+ img1
ggplot() +
  geom_line(data=conn_df, aes(ts, conns), color="lightslategray") +
  scale_y_comma() +
  theme_ipsum_rc(grid="XY")

anomalies <- ad_ts(conn_df, max_anoms = 0.05, direction = "both")

#+ img2
ggplot() +
  geom_line(data=conn_df, aes(ts, conns), color="lightslategray") +
  geom_point(data=anomalies, aes(timestamp, anoms), color="red") +
  scale_y_comma() +
  theme_ipsum_rc(grid="XY")
