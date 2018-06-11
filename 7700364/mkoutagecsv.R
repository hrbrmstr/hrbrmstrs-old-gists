#!/usr/bin/Rscript
# running in a cron job so no spurious text pls

options(warn=-1)
options(show.error.messages=FALSE)

suppressMessages(library(methods))
suppressMessages(library(zoo))
library(chron)
library(xts)
library(reshape2)
library(ggplot2)
library(scales)
library(DBI)
library(RMySQL)

m <- dbDriver("MySQL");
con <- dbConnect(m, user='DBUSER', password='DBPASSWORD', host='localhost', dbname='DBNAME');
res <- dbSendQuery(con, "SELECT * FROM outage")
outages <- fetch(res, n = -1)
outages$ts <- as.POSIXct(gsub("\\:[0-9]+\\..*$","", outages$ts), format="%Y-%m-%d %H:%M")

for (county in unique(outages$county)) {
  
  outage.raw <- outages[outages$county == county,c(1,4)]
  
  outage.zoo <- zoo(outage.raw$withoutpower, outage.raw$ts)
  
  complete.zoo <- merge(outage.zoo, zoo(, seq(start(outage.zoo), max(outages$ts), by="15 min")), all=TRUE)
  complete.zoo[is.na(complete.zoo)] <- 0
  
  hourly.zoo <- last(to.hourly(complete.zoo), "30 days")
    
  df <- data.frame(hourly.zoo)
  df <- data.frame(ts=rownames(df), withoutPower=df$complete.zoo.High)
  
  write.csv(df, sprintf("OUTPOUT_LOCATION/%s.csv",county), row.names=FALSE)
  
}

