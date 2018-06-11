library(magrittr)
library(rvest)
library(data.table)
library(dplyr)
library(pbapply)
library(stringr)

fetch_attendance <- function(year=1990) {
  url <- sprintf("http://www.baseball-reference.com/leagues/MLB/%s-misc.shtml", year)
  html(url) %>% html_table %>% .[[1]] %>% mutate(year=year)
}

make_numeric <- function(x) {
  x %>% 
    str_replace_all(",", "") %>%    # remove all commas
    str_replace_all("[$]", "") %>%  # remove all $
    as.numeric
}

attendance <- rbindlist(pblapply(1950:2010, fetch_attendance))

setnames(attendance, colnames(attendance), 
         c("tm", "attendance", "attend_per_game", "batage", "page",
           "bpf", "ppf", "n_hof", "n_aallstars", "n_a_ta_s", "est_payroll", 
           "time", "managers", "year"))

attendance %<>% 
  mutate(attendance=make_numeric(attendance),
         attend_per_Game=make_numeric(attend_per_game),
         est_payroll=make_numeric(est_payroll))


