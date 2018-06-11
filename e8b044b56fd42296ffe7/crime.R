library(dplyr)
library(rvest)
library(streamgraph)
library(htmltools)

# I'm using disastecenter.com since the FBI API is stupid. I should just wrap
# this into a data package at some point

get_crime <- function(state) {

  urle <- "http://www.disastercenter.com/crime/%scrime.htm"
  urln <- "http://www.disastercenter.com/crime/%scrimn.htm"
  url <- ""

  if (state %in% c("ne", "nj", "mo", "ms", "mt", "nc", "nd", "nm", "ok")) {
    url <- sprintf(urln, state)
  } else if (state == "ks") {
    url <- sprintf(urle, "kn")
  } else {
    url <- sprintf(urle, state)
  }

  pg <- html(url)
  tabs <- pg %>% html_nodes("table")

  crimes <- tabs[[5]] %>%  html_table(header=FALSE, fill=TRUE)
  crimes %>%
    filter(grepl("^[[:digit:]]", X1)) %>%
    mutate_each(funs(as.numeric(gsub("[^[:digit:]]", "", .))), starts_with("X")) %>%
    mutate(State=state) -> crimes
  colnames(crimes) <- c("Year", "Population", "Index", "Violent", "Property", "Murder",
                        "Rape", "Robbery", "Assault", "Burglary", "Larceny", "Vehicle", "State")

  rate_per_100k <- tabs[[8]] %>%  html_table(header=FALSE, fill=TRUE)
  rate_per_100k %>%
    filter(grepl("^[[:digit:]]", X1)) %>%
    mutate_each(funs(as.numeric(gsub("[^[:digit:]]", "", .))), starts_with("X")) %>%
    mutate(State=state) -> rate_per_100k
  colnames(rate_per_100k) <- c("Year", "Population", "Index", "Violent", "Property", "Murder",
                               "Rape", "Robbery", "Assault", "Burglary", "Larceny", "Vehicle", "State")

  if (state == "tn") {
    data.frame(rate_per_100k) %>%
      select(1:13) %>%
      mutate(State="tn") -> rate_per_100k
  }

  return(list(crimes=crimes, rate_per_100k=rate_per_100k))

}

# Get all crimes/rates ----------------------------------------------------

crimes <- pblapply(tolower(state.abb), function(x) { get_crime(x) })

# Fix data errors ---------------------------------------------------------

crimes[[5]]$crimes[43, "Burglary"] <- 238428
crimes[[42]]$rate_per_100k[42, "Larceny"] <- 28436
crimes[[42]]$rate_per_100k[46, "Larceny"] <- 28436
crimes[[10]]$rate_per_100k[46, "Larceny"] <- 27330
crimes[[10]]$rate_per_100k[46, "Assault"] <- 2625
crimes[[14]]$rate_per_100k[46, "Assault"] <- 1809
crimes[[25]]$rate_per_100k[43, "Assault"] <- 3834

# Make the data frames ----------------------------------------------------

rate <- bind_rows(lapply(crimes, function(x) { return(x$rate_per_100k) }))
crime <- bind_rows(lapply(crimes, function(x) { return(x$crimes) }))

us_ucr <- list(crimes=data.frame(crime), rates=data.frame(rate))
comment(us_ucr) <- "US Unified Crime Reporting Statistics (rates/100K and raw counts) 1960-2013. 'crimes' are raw counts. 'rates' are per/100k population"

# Grah ƒ ------------------------------------------------------------------

graph_crime_rate <- function(crime_dat, rate_dat, variable) {

  crime_dat %>%
    gather(crime, value, Property, Larceny, Burglary, Assault,
           Vehicle, Violent, Robbery, Rape, Murder) -> crime_long

  rate_dat %>%
    gather(crime, value, Property, Larceny, Burglary, Assault,
           Vehicle, Violent, Robbery, Rape, Murder) -> rate_long

  html_print(
    tagList(HTML("<style>h3 { font-family:sans-serif; </style>"),

      tags$div(h3(sprintf("%s Crimes Per State", variable)),
               crime_long %>%
                 filter(crime==variable) %>%
                 streamgraph("State", "value", "Year") %>%
                 sg_fill_tableau() %>%
                 sg_add_marker(x=as.Date("1990-01-01")) %>%
                 sg_add_marker(x=as.Date("2000-01-01"), label="http://bit.ly/rcrimegraph", anchor="end") %>%
                 sg_legend(show=TRUE)),

      HTML("<hr noshade style='margin-top:10px; margin-bottom: 10px'/>"),

      tags$div(h3(sprintf("%s Crime Rate/100K Per State", variable)),
               rate_long %>%
                 filter(crime==variable) %>%
                 streamgraph("State", "value", "Year") %>%
                 sg_fill_tableau() %>%
                 sg_add_marker(x=as.Date("1990-01-01")) %>%
                 sg_add_marker(x=as.Date("2000-01-01"), label="http://bit.ly/rcrimegraph", anchor="end") %>%
                 sg_legend(show=TRUE))
    ))


}

# Graph! ------------------------------------------------------------------

graph_crime_rate(crime, rate, "Property")
graph_crime_rate(crime, rate, "Larceny")
graph_crime_rate(crime, rate, "Burglary")
graph_crime_rate(crime, rate, "Assault")
graph_crime_rate(crime, rate, "Vehicle")
graph_crime_rate(crime, rate, "Violent")
graph_crime_rate(crime, rate, "Robbery")
graph_crime_rate(crime, rate, "Rape")
graph_crime_rate(crime, rate, "Murder")

