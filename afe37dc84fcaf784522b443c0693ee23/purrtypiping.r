#' ---
#' title: "Purrr-ty Nice Piping"
#' output: rmarkdown::html_document
#' ---

#' A small example of using the `purrr` package in pipes for some data munging before
#' analysis/plotting (using a data set from this week's Data is Plural newsletter).

#+ message=FALSE
library(readxl)
library(purrr)
library(stringi)
library(dplyr)
library(ggplot2)  # devtools::install_github("hadley", "ggplot2")
library(hrbrmisc) # devtools::install_github("hrbrmstr", "hrbrmisc")

#' This saves bandwidth for both you and the server

las_url <- "http://www.faa.gov/about/initiatives/lasers/laws/media/laser_incidents_2010-2014.xls"
las_fil <- basename(las_url)
if (!file.exists(las_fil)) download.file(las_url, las_fil)

#' How many tabs/sheets do we have? I'm using the `capture.output()` hack to
#' avoid printing diagnostic messages from `readxl` that should be sent as
#' R messages but are rendered to `stdout` due to the way it's coded in C++.

tmp <- capture.output(
  sheet_names <- excel_sheets(las_fil)
)
(total_sheets <- length(sheet_names))

#' Let's get them all (cheating a bit since I already know the data types).

tmp <- capture.output(
  lasers <- map(1:total_sheets, read_excel, path=las_fil,
                col_types=c("date", "text", "text", "numeric", rep("text", 7)))
)

#' Are all the columns named the same (and do all the sheets have the same # of them?)

map(lasers, colnames)

#' Let's grab the time of day the incidents were reported (across the entire corpus)
#' and figure out the hour (UTC). We'll use this to make a simple bar chart.

map(lasers, "TIME (UTC)") %>%               # handy way to get the same column from all data frames
  flatten_chr() %>%                         # we just want a single character vector
  discard(is.na) %>%                        # some rows are Total rows or blank, get rid of them
  stri_replace_all_regex("\\..*$", "") %>%  # some cells come over with .0000, clean them up
  sprintf("%04s", .) %>%                    # some of ^ need some :heart:
  stri_sub(1,2) %>%                         # get the hour
  discard(`%in%`, c("UN", "  ")) %>%        # remove blanks and "UN" (unknown) times
  data_frame(time=.) %>%                    # make a data frame
  count(time) -> events                     # count up the events per hour

#' I don't pipe in packages but they are super-handy for this type of work and
#' `purrr`, `dplyr` and even `stringi` functions take the data element as the
#' first parameter, so they fit into the piping idiom well.
#'
#' Now, we make a bar chart, and try to make the most effective use of plot
#' real estate as possible.

#+ fig.retina=2, fig.width=9, fig.height=4.5
gg <- ggplot()
gg <- gg + geom_bar(data=events, aes(time, n), width=0.75,
                    stat="identity", fill="maroon", color="white")
gg <- gg + scale_x_discrete(expand=c(0,0), labels=c("00\n(UTC)", sprintf("%02d", 1:23)))
gg <- gg + scale_y_continuous(expand=c(0,0), limits=c(0, 3600),
                     breaks=seq(0, 3500, 500), label=scales::comma)
gg <- gg + geom_label(data=data.frame(), aes(x=0, y=3500, label="# Events Reported"),
                      label.size=0, label.padding=grid::unit(0, "null"),
                      hjust=0, family="Arial Narrow", fontface="italic", size=3)
gg <- gg + labs(x=NULL, y=NULL,
       title="Reported Laser Incidents for 2010-2014",
       subtitle="Unsurprisingly, laser pointer 'events' seem to occur when it's nighttime (0000 UTC ==~ 2000 ET)",
       caption="Source: http://www.faa.gov/about/initiatives/lasers/laws/")
gg <- gg + theme_hrbrmstr_an(grid="Y", axis="x")
gg <- gg + theme(axis.text.x=element_text(size=8))
gg <- gg + theme(plot.caption=element_text(margin=margin(t=3)))
gg

#' This can be enhanced by taking the *CITY*, *STATE* and *DATE* columns into account
#' and converting the UTC time to local time and also figure out the amount of daylight
#' with `maptools::sunriset` to validate the posit that the laser events are
#' truly associated with the amount of daylight.
