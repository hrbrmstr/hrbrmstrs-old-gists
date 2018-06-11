
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

pkg <- c("shiny", "zipcode", "pbapply", "data.table", "dplyr", 
         "ggplot2", "grid", "gridExtra", "stringi", "magrittr")
new.pkg <- pkg[!(pkg %in% installed.packages())]
if (length(new.pkg)) {
  install.packages(new.pkg)
}

library(shiny)
library(zipcode)
library(pbapply)
library(data.table)
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)
library(stringi)
library(magrittr)

data(zipcode)

states <- read.table(text="Number,ISO2,Name
01,AL,Alabama
02,AZ,Arizona
03,AR,Arkansas
04,CA,California
05,CO,Colorado
06,CT,Connecticut
07,DE,Delaware
08,FL,Florida
09,GA,Georgia
10,ID,Idaho
11,IL,Idaho
12,IN,Indiana
13,IA,Iowa
14,KS,Kansas
15,KY,Kentucky
16,LA,Louisiana
17,ME,Maine
18,MD,Maryland
19,MA,Massachusetts
20,MI,Michigan
21,MN,Minnesota
22,MS,Mississippi
23,MO,Missouri
24,MT,Montana
25,NE,Nebraska
26,NV,Nevada
27,NH,New Hampshire
28,NJ,New Jersey
29,NM,New Mexico
30,NY,New York
31,NC,North Carolina
32,ND,North Dakota
33,OH,Ohio
34,OK,Oklahoma
35,OR,Oregon
36,PA,Pennsylvania
37,RI,Rhode Island
38,SC,South Carolina
39,SD,South Dakota
40,TN,Tennessee
41,TX,Texas
42,UT,Utah
43,VT,Vermont
44,VA,Virginia
45,WA,Washington
46,WV,West Virginia
47,WI,Wisconsin
48,WY,Wyoming", header=TRUE, sep=",", stringsAsFactors=FALSE,
                     colClasses=c("character", "character", "character"))

closestStation <- function(stations, lat, lon) {
  index <- which.min(sqrt((stations$latitude-lat)^2 +
                            (stations$longitude-lon)^2))
  stations[index,]
}


shinyServer(function(input, output) {

  output$snowPlot <- renderPlot({

    if (input$bye != 0) {
      quit(save="no", runLast=FALSE)()
    }

    if (input$lookup == 0) {
      return()
    }

    withProgress(message = 'Retrieving snowfall data...', value = 0, {

      loc <- subset(zipcode, zip==isolate({ input$zip }))

      stations <- read.fwf("http://cdiac.ornl.gov/ftp/ushcn_daily/ushcn-stations.txt",
                           widths=c(6, 9, 10, 7, 3, 31, 7, 7, 7, 3),
                           col.names=c("coop_id", "latitude", "longitude", "elevation",
                                       "state", "name", "component_1", "component_2",
                                       "component_3", "utc_offset"),
                           colClasses=c("character", "numeric", "numeric", "numeric",
                                        "character", "character", "character", "character",
                                        "character", "character"),
                           comment.char="", strip.white=TRUE)

      my_station <- closestStation(stations, loc$latitude, loc$longitude)

      state_file <- sprintf("http://cdiac.ornl.gov/ftp/ushcn_daily/state%s_%s.txt.gz", states[states$ISO2==my_station$state,]$Number, my_station$state)


      snow <- readLines(gzcon(url(state_file)))
      snow <- grep("SNOW", snow, value=TRUE)
      snow <- grep(sprintf("^%s", my_station$coop_id), snow, value=TRUE)

      snow_dat <- rbindlist(pblapply(snow, function(x) {

        rbindlist(lapply(1:31, function(i) {

          # record format described here:
          # http://cdiac.ornl.gov/ftp/ushcn_daily/data_format.txt

          start <- 17 + (i-1)*8

          list(coop_id=substr(x, 1, 6),
               date=sprintf("%s-%02d-%02d", substr(x, 7, 10), as.numeric(substr(x, 11, 12)), i),
               element=substr(x, 13, 16),
               value=as.numeric(substr(x, start, start+4)),
               mflag=substr(x, start+5, start+5),
               qflag=substr(x, start+6, start+6),
               sflag=substr(x, start+7, start+7))

        }))

      }))

      snow_dat <- snow_dat %>% filter(value != -9999)

      snow_dat$date <- as.Date(snow_dat$date)
      snow_dat <- snow_dat %>% filter(!is.na(date))

      snow_dat$year <- format(snow_dat$date, "%Y")

      snow_dat$doy <- as.numeric(format(snow_dat$date, "%j"))
      snow_dat$doy <- ifelse(snow_dat$doy<=180,
                             snow_dat$doy + as.numeric(format(as.Date(sprintf("%s-12-31", snow_dat$year)), "%j")),
                             snow_dat$doy)

      # now the fun begins

      first <- snow_dat %>%
        filter(value>0) %>%                           # ignore 0 values
        filter(date>=as.Date("1950-01-01")) %>%       # start at 1950 (arbitrary)
        merge(stations, by="coop_id", all.x=TRUE) %>% # merge station details
        group_by(coop_id, year) %>%                   # group by station and year
        arrange(doy) %>%                              # sort by our munged day of year
        filter(row_number(doy) == 1) %>%              # grab the first entry by group
        select(name, state, date, value, doy)         # we only need some variables

      # make a nice title for the visualization
      title_1 <- sprintf("First observed snowfall (historical) at\nObserver Station: %s, %s", stri_trans_totitle(unique(first$name)), unique(first$state))

      min_doy <- min(first$doy) - 20
      max_doy <- max(first$doy) + 20

      # an overused plot by me, but I really like the dot-line charts and we
      # add a twist by using a snowflake for the point and use icy blue colors
      gg <- ggplot(first, aes(y=year, x=doy))
      gg <- gg + geom_segment(xend=min_doy, aes(yend=year), color="#9ecae1", size=0.25)
      gg <- gg + geom_point(aes(color=coop_id), shape=8, size=3, color="#3182bd")
      gg <- gg + geom_text(aes(label=format(date, "%b-%d")), size=3, hjust=-0.2)
      gg <- gg + scale_x_continuous(expand=c(0, 0), limits=c(min_doy, max_doy))
      gg <- gg + labs(x=NULL, y=NULL, title=title_1)
      gg <- gg + theme_bw()
      gg <- gg + theme(legend.position="none")
      gg <- gg + theme(panel.grid=element_blank())
      gg <- gg + theme(panel.border=element_blank())
      gg <- gg + theme(axis.ticks.x=element_blank())
      gg <- gg + theme(axis.ticks.y=element_blank())
      gg <- gg + theme(axis.text.x=element_blank())
      gg <- gg + theme(axis.text.y=element_text(color="#08306b"))
      by_year <- gg

      # we're going to pair the dot-line plot with a boxplot, but I also want to
      # give some indication of the most likely range for the first snowfall, so
      # we grab the quartiles via summary and use them to annotate the second graph
      wx_range <- summary(as.Date(format(first$date, "2013-%m-%d")))
      names(wx_range) <- NULL
      min_wx <- gsub("2013-", "", wx_range[2])
      max_wx <- gsub("2013-", "", wx_range[5])
      title_2 <- sprintf("Most likely first snowfall will be between %s & %s", min_wx, max_wx)

      # we use a trick to line up the box plot with the dot-line plot by
      # using the same character width y-axis labels but making them the background
      # color (in this case, white) and keeping the x-axis limits the same. there
      # may be another way to do this but this is quick, and easy to remember.
      # a violin plot would work here as well
      gg <- ggplot(first %>% mutate(name="0000"), aes(name, doy))
      gg <- gg + geom_boxplot(fill="#3182bd", color="#08306b", outlier.colour="#08306b")
      gg <- gg + scale_y_continuous(expand=c(0, 0),
                                    limits=c(min(first$doy)-20, max(first$doy)+20))
      gg <- gg + coord_flip()
      gg <- gg + labs(x=NULL, y=NULL, title=title_2)
      gg <- gg + theme_bw()
      gg <- gg + theme(legend.position="none")
      gg <- gg + theme(panel.grid=element_blank())
      gg <- gg + theme(panel.border=element_blank())
      gg <- gg + theme(axis.ticks.x=element_blank())
      gg <- gg + theme(axis.text.x=element_blank())
      gg <- gg + theme(axis.ticks.y=element_line(color="white"))
      gg <- gg + theme(axis.text.y=element_text(color="white"))
      gg <- gg + theme(plot.title=element_text(size=11))
      box_wx <- gg

      # final presentation
      grid.arrange(by_year, box_wx, nrow=2, heights=unit(c(0.9, 0.1), "npc"))

    })

  }, height=700, width=500)

})
