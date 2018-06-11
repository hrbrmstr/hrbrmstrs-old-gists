library(maps)
library(data.table)
library(dplyr)
library(ggplot2)
library(grid)
library(RColorBrewer)

# takes in a numeric vector and returns a sequence from low to high
rangeseq <- function(x, by=1) {
  rng <- range(x)
  seq(from=rng[1], to=rng[2], by=by)
}

# etract the months (as a factor of full month names) from
# a date+time "x" that can be converted to a POSIXct object,
extractMonth <- function(x) {
  months <- format(as.POSIXct(x), "%m")
  factor(months, labels=month.name[rangeseq(as.numeric(months))])
}

# etract the years (as a factor of full 4-charater-digit years) from
# a date+time "x" that can be converted to a POSIXct object,
extractYear <- function(x) {
  factor(as.numeric(format(as.POSIXct(x), "%Y")))
}

# get from: ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/all/csv/Allstorms.ibtracs_all.v03r06.csv.gz
storms_file <- "data/Allstorms.ibtracs_all.v03r06.csv"
storms <-  fread(storms_file, skip=10, select=1:18)

col_names <- c("Season", "Num", "Basin", "Sub_basin", "Name", "ISO_time", "Nature",
             "Latitude", "Longitude", "Wind.kt", "Pressure.mb", "Degrees_North", "Deegrees_East")
setnames(storms, paste0("V", c(2:12, 17, 18)), col_names)

# use dplyr idioms to filter & mutate the data

storms <- storms %>%
  filter(Latitude > -999,                                  # remove missing data
         Longitude > -999,
         Wind.kt > 0,
         !(Name %in% c("UNNAMED", "NONAME:UNNAMED"))) %>%
  mutate(Basin=gsub(" ", "", Basin),                       # clean up fields
         ID=paste(Name, Season, sep="."),
         Month=extractMonth(ISO_time),
         Year=extractYear(ISO_time)) %>%
  filter(Season >= 1989, Basin %in% "NA")                  # limit to North Atlantic basin

season_range <- paste(range(storms$Season), collapse=" - ")
knots_range <- range(storms$Wind.kt)

# setup base plotting parameters (these won't change)

base <- ggplot()
base <- base + geom_polygon(data=map_data("world"),
                            aes(x=long, y=lat, group=group),
                            fill="gray25", colour="gray25", size=0.2)
base <- base + scale_color_gradientn(colours=rev(brewer.pal(n=9, name="RdBu")),
                                     space="Lab", limits=knots_range)
base <- base + xlim(-138, -20) + ylim(3, 55)
base <- base + coord_map()
base <- base + labs(x=NULL, y=NULL, title=NULL, colour = "Wind (knots)")
base <- base + theme_bw()
base <- base + theme(text=element_text(family="Arial", face="plain", size=rel(5)),
                     panel.background = element_rect(fill = "gray10", colour = "gray30"),
                     panel.margin = unit(c(0,0), "lines"),
                     panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(),
                     plot.margin = unit(c(0,0,0,0), "lines"),
                     axis.text.x = element_blank(),
                     axis.text.y = element_blank(),
                     axis.ticks = element_blank(),
                     legend.position = c(0.25, 0.1),
                     legend.background = element_rect(fill="gray10", color="gray10"),
                     legend.text = element_text(color="white", size=rel(2)),
                     legend.title = element_text(color="white", size=rel(5)),
                     legend.direction = "horizontal")

# loop over each year, producing plot files that accumulate tracks over each month

for (year in unique(storms$Year)) {

  storm_ids <- unique(storms[storms$Year==year,]$ID)

  for (i in 1:length(storm_ids)) {

    storms_yr <- storms %>% filter(Year==year, ID %in% storm_ids[1:i])

    message(sprintf("%s %s", year, storm_ids[i]))

    gg <- base
    gg <- gg + geom_path(data=storms_yr,
                         aes(x=Longitude, y=Latitude, group=ID, colour=Wind.kt),
                         size=1.0, alpha=1/4)
    gg <- gg + geom_text(label=year, aes(x=-135, y=51), size=rel(6), color="white", vjust=1)
    gg <- gg + geom_text(label=paste(gsub(".[[:digit:]]+$", "", storm_ids[1:i]), collapse="\n"),
                         aes(x=-135, y=49.5), size=rel(4.5), color="white", vjust=1)

    # change "quartz" to "cairo" if you're not on OS X

    png(filename=sprintf("output/%s%03d.png", year, i),
        width=1920, height=1080, type="quartz", bg="gray25")
    print(gg)
    dev.off()

  }

}

# convert to mp4 animation - needs imagemagick
system("convert -delay 8 output/*png output/hurr-1.mp4")
# unlink("output/*png") # do this after verifying convert works

# take an alternate approach for accumulating the entire hurricane history
# start with the base, but add to the ggplot object in a loop, which will
# accumulate all the tracks.

gg <- base

for (year in unique(storms$Year)) {

  storm_ids <- unique(storms[storms$Year==year,]$ID)

  for (i in 1:length(storm_ids)) {

    storms_yr <- storms %>% filter(ID %in% storm_ids[i])

    message(sprintf("%s %s", year, storm_ids[i]))
    gg <- gg + geom_path(data=storms_yr,
                         aes(x=Longitude, y=Latitude, group=ID, colour=Wind.kt),
                         size=1.0, alpha=1/4)

    png(filename=sprintf("output/%s%03d.png", year, i),
        width=1920, height=1080, type="quartz", bg="gray25")
    print(gg)
    dev.off()

  }

}

system("convert -delay 8 output/*png output/hurr-2.mp4")
# unlink("output/*png") # do this after verifying convert works

