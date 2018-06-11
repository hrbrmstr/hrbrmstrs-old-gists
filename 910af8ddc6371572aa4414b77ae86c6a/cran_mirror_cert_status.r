library(rvest)
library(urltools)
library(rmarkdown)

# Some Rmd template setup -----------------------------------------------------------

preamble <- '---
title: "CRAN Mirrors Certificate Expiration Dashboard (Days left from %s)"
output:
  flexdashboard::flex_dashboard:
    orientation: rows
    vertical_layout: scroll
---
```{r setup, include=FALSE}
library(flexdashboard)
library(openssl)
library(purrr)
library(dplyr)
library(scales)
'

after_data <- '

dsc <- safely(download_ssl_cert);

expires_delta <- function(site) {

  site_info <- strsplit(site, ":")[[1]]
  port <- as.numeric(site_info[2])

  chain_res <- dsc(site_info[1], port)
  if (!is.null(chain_res$result)) {

    chain <- chain_res$result

    valid_from <- as.Date(as.POSIXct(as.list(chain[[1]])$validity[1],
                                     "%b %d %H:%M:%S %Y", tz="GMT"))
    expires_on <- as.Date(as.POSIXct(as.list(chain[[1]])$validity[2],
                                     "%b %d %H:%M:%S %Y", tz="GMT"))

    data_frame(site=site_info[1],
               valid_from=valid_from,
               expires_on=expires_on,
               cert_valid_length=expires_on-valid_from,
               days_left_from_valid=expires_on - valid_from,
               days_left_from_today=expires_on - Sys.Date(),
               days_left_from_today_lab=comma(expires_on - Sys.Date()),
               color="primary",
               color=ifelse(days_left_from_today<=15, "danger", color),
               color=ifelse(days_left_from_today>15 & days_left_from_today<60, "warning", color))

  } else {

    data_frame(site=site_info[1],
               valid_from=NA,
               expires_on=NA,
               cert_valid_length=NA,
               days_left_from_valid=NA,
               days_left_from_today=NA,
               days_left_from_today_lab="Host unreachable",
               color="info")

  }

}

ssl_df <- arrange(map_df(sites, expires_delta), days_left_from_today)
```

'

# Get a list of all https-enabled CRAN mirrors --------------------------------------

pg <- read_html("https://cran.r-project.org/mirrors.html")
sites <- sprintf("%s:443", domain(html_attr(html_nodes(pg, "td > a[href^='https:']"), "href")))

# Capture this vector for use in the R markdown template ----------------------------

setup_data <- capture.output(dput(sites))

# Create a temporary Rmd file -------------------------------------------------------

dashfile <- tempfile(fileext=".Rmd")

# Write out the initial template bits we've been making -----------------------------

cat(sprintf(preamble, Sys.Date()), "sites <- ", setup_data, after_data, file=dashfile)

# 5 valueBoxes per row seems like a good # ----------------------------------------

max_vbox_per_row <- 5

n_dashrows <- ceiling(length(sites)/max_vbox_per_row)

# Generate a valueBox() per site, making rows every max_vbox_per_row ----------------

for (i in 1:length(sites)) {

  if (((i-1) %% max_vbox_per_row) == 0) {
    cat('
Row
-------------------------------------

', file=dashfile, append=TRUE)
  }

  cat(sprintf("\n### %s\n```{r}\n", gsub(":.*$", "", sites[i])), file=dashfile, append=TRUE)
  cat(sprintf('valueBox(ssl_df[%d, "days_left_from_today_lab"], icon="fa-lock", color=ssl_df[%d, "color"])\n```\n', i, i),
      file=dashfile, append=TRUE)
}

# Temporary html file (you prbly want this more readily available -------------------

dir <- tempfile()
dir.create(dir)
dash_html <- file.path(dir, "sslexpires.html")

# Render the dashboard --------------------------------------------------------------

rmarkdown::render(dashfile, output_file=dash_html)

# View in RStudio -------------------------------------------------------------------

rstudioapi::viewer(dash_html)

# Clean up --------------------------------------------------------------------------

unlink(dashfile)
