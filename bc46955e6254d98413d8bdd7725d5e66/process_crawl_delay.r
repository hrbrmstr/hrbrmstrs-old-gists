#!/usr/bin/Rscript
suppressPackageStartupMessages(library(warrc))
suppressPackageStartupMessages(library(stringi))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(robotstxt))
suppressPackageStartupMessages(library(urltools))

args <- commandArgs(trailingOnly = TRUE)

s_parse_robotstxt <- safely(parse_robotstxt)

check_delay <- function(fil) {

  bf <- basename(fil)

  w <- warc_open(fil)
  xdf <- as_data_frame(w)
  warc_close(w)

  filter(xdf, warc_type == "warcinfo") -> winfo
  filter(xdf, warc_type == "response") -> resp

  total_sites <- nrow(resp)

  pb <- progress_estimated(nrow(resp))
  map2(resp$payload, resp$warc_target_uri, ~{
    pb$tick()$print()
    tmp <- as_response(.x, .y)
    ret <- NULL
    if (status_code(tmp) < 400) {
      res <- content(tmp, as="text", encoding="UTF-8")
      res <- s_parse_robotstxt(res)
      if (!is.null(res$result)) {
        c_del <- res$result$crawl_delay
        if (nrow(c_del) > 0) ret <- mutate(c_del, dom = domain(.y))
      }
    }
    ret
  }) -> xr

  discard(xr, is.null) %>%
    discard(~nrow(.x) == 0) %>%
    bind_rows() %>%
    mutate(
      wfile = winfo$warc_filename[1],
      total_sites = total_sites
    ) %>%
    select(-field) %>%
    write_csv(sprintf("~/cdout/%s-%s-.csv", bf, winfo$warc_filename[1]))

}

message("Processing ", args, "\n")

csv_fil <- sprintf("~/cdout/%s.csv", basename(args))
fils <- list.files(args, full.names=TRUE)
walk(fils, check_delay)