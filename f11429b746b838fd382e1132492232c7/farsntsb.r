library(foreign)
library(purrr)
library(data.table)
library(dplyr)
library(ggplot2)  # hadley/ggplot2
library(scales)
library(ggalt)
library(hrbrmisc) # hrbrmstr/hrbrmisc

# keep the downloads contained ------------------------------------------------------

dir.create("fars")
setwd("fars")

# *most* of the accident dbf files are named properly -------------------------------

urls <- sprintf("ftp://ftp.nhtsa.dot.gov/FARS/%s/DBF/FARS%s.zip",
                c(1975:1993, 2001:2014), c(1975:1993, 2001:2014))
fils <- basename(urls)

# at least the ones that aren't have an alternate uniform naming convention ---------

urls2 <- sprintf("ftp://ftp.nhtsa.dot.gov/FARS/%s/DBF/FARSDBF%s.zip",
                c(1994:2000), sprintf("%02d", c(94:99, 0)))
fils2 <- basename(sprintf("FARS%s.zip", 1994:2000))

# optimize the downloads by using url & file vectors --------------------------------

download.file(c(urls, urls2), c(fils, fils2))

# unzip each archive into a year directory ------------------------------------------

for (f in as.character(1975:2014)) {
  unzip(sprintf("FARS%s.zip", f), exdir=f)
}

# the accident files were also named inconsistently, but we can grab'em all ---------

accident_fils <- list.files(as.character(1975:2014), "^[aA].*.(dbf|DBF)", full.names=TRUE)

# DBF format (sigh) and columns badly formed enough that we need ----------- --------
# rbindlist() from data.table vs map_df() or bind_rows()

accidents <- rbindlist(map(accident_fils, function(x) {
  y <- read.dbf(x, as.is=TRUE)
  setNames(y, tolower(colnames(y)))
}), fill=TRUE)

# clean up some columns -------------------------------------------------------------

mutate(accidents,
       year=ifelse(year<100, 1900+year, year),
       date=as.Date(sprintf("%04d-%02d-%02d", year, month, day))) -> accidents

# one type of overview plot ---------------------------------------------------------

gg <- ggplot(count(filter(accidents, !is.na(fatals) & fatals>0), year), aes(factor(year), n))
gg <- gg + geom_lollipop()
gg <- gg + scale_x_discrete(name=NULL, breaks=c(1975, 1980, 1990, 2000, 2010, 2014))
gg <- gg + scale_y_continuous(name=NULL, labels=comma)
gg <- gg + expand_limits(y=0)
gg <- gg + labs(title="Annual, Total Automobile Fatal Crashes (1975-2014)",
                caption="Source: National Highway Traffic Safety Administration (NHHTSA)\nFatality Analysis Reporting System (FARS) Encyclopedia\nhttp://www-fars.nhtsa.dot.gov/Crashes/CrashesTime.aspx")
gg <- gg + theme_hrbrmstr_an(grid="Y")
gg <- gg + theme(axis.text.x=element_text(margin=margin(t=-20)))
gg <- gg + theme(axis.text.y=element_text(vjust=c(0, rep(0.5, 5))))
gg