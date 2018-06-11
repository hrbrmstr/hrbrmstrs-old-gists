#' ---
#' title: "DisembaRking"
#' author: "@hrbrmstr"
#' date: ""
#' output:
#'   html_document:
#'     code_download: true
#' ---
#+ include=FALSE
knitr::opts_chunk$set(message=FALSE, warning=FALSE)

#+ letsgo
library(rvest)
library(stringi)
library(pdftools)
library(hrbrthemes)
library(tidyverse)

#' some URLs generate infinite redirection loops so be safe out there

safe_read_html <- safely(read_html)

#' grab the individual page URLs for each month available in each year

c("https://www.transportation.gov/airconsumer/air-travel-consumer-reports-2017",
  "https://www.transportation.gov/airconsumer/air-travel-consumer-reports-2016",
  "https://www.transportation.gov/airconsumer/air-travel-consumer-reports-2015") %>%
  map(function(x) {
    read_html(x) %>%
      html_nodes("a[href*='air-travel-consumer-report']") %>%
      html_attr('href')
  }) %>%
  flatten_chr() %>%
  discard(stri_detect_regex, "feedback|/air-travel-consumer-reports") %>% # filter out URLs we don't need
  sprintf("https://www.transportation.gov%s", .) -> main_urls # make them useful

#' now, read in all the individual pages.
#' do this separate from URL grabbing above and the PDF URL extraction
#' below just to be even safer.

map(main_urls, safe_read_html) -> pages

#' URLs that generate said redirection loops will not have a valid
#' result so ignor ethem and find the URLs for the monthly reports

discard(pages, ~is.null(.$result)) %>%
  map("result") %>%
  map(~html_nodes(., "a[href*='pdf']") %>%
        html_attr('href') %>%
        keep(stri_detect_fixed, "ATCR")) %>%
  flatten_chr() -> pdf_urls

#' download them, being kind to the DoT server and not re-downloading
#' anything we've successfully downloaded already. I really wish this
#' was built-in functionality to download.file()

dir.create("atcr_pdfs")
walk(pdf_urls, ~if (!file.exists(file.path("atcr_pdfs", basename(.))))
  download.file(., file.path("atcr_pdfs", basename(.))))

#' read in each PDF; find the pages with the tables we need to scrape;
#' enable the text table to be read with read.table() and save the
#' results

c("2017MarchATCR.pdf", "2016MarchATCR_2.pdf", "2015MarchATCR_1.pdf") %>%
  file.path("atcr_pdfs", .) %>%
  map(pdf_text) %>%
  map(~keep(.x, stri_detect_fixed, "PASSENGERS DENIED BOARDING")[[2]]) %>%
  map(stri_split_lines) %>%
  map(flatten_chr) %>%
  map(function(x) {
    y <- which(stri_detect_regex(x, "Rank|RANK|TOTAL"))
    grep("^\ +[[:digit:]]", x[y[1]:y[2]], value=TRUE) %>%
      stri_trim() %>%
      stri_replace_all_regex("([[:alpha:]])\\*+", "$1") %>%
      stri_replace_all_regex(" ([[:alpha:]])", "_$1") %>%
      paste0(collapse="\n") %>%
      read.table(text=., header=FALSE, stringsAsFactors=FALSE)
  }) -> denied

denied

map2_df(2016:2014, denied, ~{
  .y$year <- .x
  set_names(.y[,c(1:6,11)],
            c("rank", "airline", "voluntary_denied", "involuntary_denied",
              "enplaned_ct", "involuntary_db_per_10k", "year")) %>%
    mutate(airline = stri_trans_totitle(stri_trim(stri_replace_all_fixed(airline, "_", " ")))) %>%
    readr::type_convert() %>%
    tbl_df()
}) %>%
  select(-rank) -> denied

glimpse(denied)

denied

select(denied, airline, year, involuntary_db_per_10k) %>%
  group_by(airline) %>%
  mutate(yr_ct = n()) %>%
  ungroup() %>%
  filter(yr_ct == 3) %>%
  select(-yr_ct) %>%
  mutate(year = factor(year, rev(c(max(year)+1, unique(year))))) -> plot_df

str(plot_df$year)

update_geom_font_defaults(font_rc, size = 3)

#+ fig.width=7.5, fig.height=11
ggplot() +
  geom_line(data = plot_df, aes(year, involuntary_db_per_10k, group=airline, colour=airline)) +
  geom_text(data = filter(plot_df, year=='2016') %>% mutate(lbl = sprintf("%s (%s)", airline, involuntary_db_per_10k)),
            aes(x=year, y=involuntary_db_per_10k, label=lbl, colour=airline), hjust=0,
            nudge_y=c(0,0,0,0,0,0,0,0,-0.0005,0.03,0), nudge_x=0.015) +
  scale_x_discrete(expand=c(0,0), labels=c(2014:2016, ""), drop=FALSE) +
  scale_y_continuous(trans="log1p") +
  ggthemes::scale_color_tableau() +
  labs(x=NULL, y=NULL,
       title="Involuntary Disembark Rate Per 10K Passengers",
       subtitle="Y-axis log scale; Only included airlines with 3-year span data",
       caption="Source: U.S. DoT Air Travel Consumer Reports <https://www.transportation.gov/airconsumer/air-travel-consumer-reports>") +
  theme_ipsum_rc(grid="X") +
  theme(plot.caption=element_text(hjust=0)) +
  theme(legend.position="none")