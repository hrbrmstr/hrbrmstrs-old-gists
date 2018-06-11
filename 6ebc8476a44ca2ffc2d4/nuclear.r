# install.packages("devtools")
# devtools::install_github("hadley/ggplot2")

library(ggplot2)
library(dplyr)

URL <- "https://raw.githubusercontent.com/data-is-plural/nuclear-explosions/master/data/sipri-report-explosions.csv"
fil <- basename(URL)

if (!file.exists(fil)) download.file(URL, fil)
dat <- read.csv(fil, stringsAsFactors=FALSE)

dat$date <- as.Date(as.character(dat$date_long), format="%Y%m%d")
dat$year <- as.character(dat$year)
dat$yr <- as.Date(sprintf("%s-01-01", dat$year))
dat$country <- sub("^(PAKIST|INDIA)$", "INDIA & PAKISTAN", dat$country)

booms <- arrange(count(dat, country), desc(n))

by_yr_cc <- arrange(count(dat, yr, country), desc(n))
by_yr_cc$country <- factor(by_yr_cc$country, levels=unique(booms$country))

cold_war <- data.frame(xmin=as.Date("1947-01-01"),
                       xmax=as.Date("1991-01-01"))

marks <- data.frame(event=c("IAEA Established", "SALT I", "Chernobyl"),
                    date=as.Date(c("1957-07-29", "1972-05-26", "1986-04-26")),
                    y=c(80, 80, 80),
                    hjust=c(1.15, 1.15, 1.15))

# Exo2 : https://www.google.com/fonts#UsePlace:use/Collection:Exo+2

gg <- ggplot()
gg <- gg + geom_rect(data=cold_war, aes(xmin=xmin, xmax=xmax, ymin=0, ymax=Inf), 
                     color="#2b2b2b11", fill="#2b2b2b", alpha=1/20)
gg <- gg + geom_vline(data=marks, aes(xintercept=as.numeric(date)), 
                      color="black", size=0.15, linetype="dotted")
gg <- gg + geom_text(data=marks, aes(x=date, y=y, label=event, hjust=hjust),
                     family="Exo2-Medium", color="black", size=2.5)
gg <- gg + geom_segment(data=by_yr_cc, aes(x=yr, xend=yr, y=n, yend=0), 
                        size=0.3, color="#2b2b2b")
gg <- gg + geom_point(data=by_yr_cc, 
                      aes(x=yr, xend=yr, y=n, yend=0), 
                      size=0.4, color="#2b2b2b")
gg <- gg + annotate("text", x=as.Date("1948-01-01"), y=95, label="Cold War Era",
                     family="Exo2-SemiBold", size=3.5, hjust=0, vjust=1)
gg <- gg + scale_x_date(limits=c(as.Date("1945-01-01"), as.Date("1998-01-01")))
gg <- gg + scale_y_continuous(expand=c(0,0), limits=c(0,100))
gg <- gg + facet_wrap(~country, scales="free", ncol=2)
gg <- gg + labs(x=NULL, y="# explosions",
                title="Nuclear Explosions, 1945–1998",
                subtitle="From a report by the Stockholm International Peace Research Institute",
                caption="Data from: https://github.com/data-is-plural/nuclear-explosions/tree/master/data")
gg <- gg + theme_bw(base_family="Exo2-Light")
gg <- gg + theme(panel.grid.major=element_line(color="#2b2b2b", size=0.1))
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(panel.grid.major.x=element_blank())
gg <- gg + theme(panel.grid.minor.x=element_blank())
gg <- gg + theme(axis.line=element_line(color="#2b2b2b", size=0.1))
gg <- gg + theme(axis.line.x=element_line(color="#2b2b2b", size=0.1))
gg <- gg + theme(axis.line.y=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(axis.text.y=element_text(margin=margin(r=-3), size=7, vjust=c(0,0.5,0.5,0.5,1)))
gg <- gg + theme(axis.title.y=element_text(family="Exo2-Light", size=8, hjust=1))
gg <- gg + theme(panel.margin.x=unit(32, "pt"))
gg <- gg + theme(panel.margin.y=unit(24, "pt"))
gg <- gg + theme(plot.margin=unit(rep(24, 4), "pt"))
gg <- gg + theme(panel.grid.major.y=element_line(size=0.05))
gg <- gg + theme(plot.title=element_text(family="Exo 2 Black", margin=margin(b=5)))
gg <- gg + theme(plot.caption=element_text(family="Exo2-Light", size=9, margin=margin(t=12)))
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_text(family="Exo2-SemiBold", hjust=0.05))
gg
