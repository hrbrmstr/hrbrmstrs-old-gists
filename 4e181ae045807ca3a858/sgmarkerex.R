library(dplyr)
library(streamgraph)
library(pbapply)

# Grab some employment data from BLS --------------------------------------

url <- "http://www.bls.gov/lau/ststdsadata.txt"
dat <- readLines(url)

# Small function to grab data for a particular state ----------------------

get_state_data <- function(state) {

  section <- paste("^%s|    (", paste0(month.name, sep="", collapse="|"), ")\ +[[:digit:]]{4}", sep="", collapse="")
  section <- sprintf(section, state)
  vals <- gsub("^\ +|\ +$", "", grep(section, dat, value=TRUE))

  state_vals <- gsub("^.* \\.+", "", vals[seq(from=2, to=length(vals), by=2)])

  cols <- read.table(text=state_vals)
  cols$month <- as.Date(sprintf("01 %s", vals[seq(from=1, to=length(vals), by=2)]),
                        format="%d %B %Y")
  cols$state <- state

  cols %>%
    select(8:9, 1:8) %>%
    mutate(V1=as.numeric(gsub(",", "", V1)),
           V2=as.numeric(gsub(",", "", V2)),
           V4=as.numeric(gsub(",", "", V4)),
           V6=as.numeric(gsub(",", "", V6)),
           V3=V3/100,
           V5=V5/100,
           V7=V7/100) %>%
    rename(civ_pop=V1,
           labor_force=V2, labor_force_pct=V3,
           employed=V4, employed_pct=V5,
           unemployed=V6, unemployed_pct=V7)

}

# lazily get them all -----------------------------------------------------

state_unemployment <- bind_rows(pblapply(state.name, get_state_data))

# filter out just a few (New England + cpl others) ------------------------

state_unemployment %>%
  filter(state %in% c("California", "Ohio", "Rhode Island", "Maine",
                      "Massachusetts", "Connecticut", "Vermont",
                      "New Hampshire", "Nebraska")) -> some

# Make the streamgraph ----------------------------------------------------

streamgraph(some, "state", "unemployed_pct", "month", width=700, height=400) %>%
  sg_axis_x(tick_interval=10, tick_units = "year", tick_format="%Y") %>%
  sg_axis_y(0) %>%
  sg_add_marker(x=as.Date("1981-07-01"), "1981 (10.8%)", anchor="end") %>%
  sg_add_marker(x=as.Date("1990-07-01"), "1990 (7.8%)", anchor="start") %>%
  sg_add_marker(x=as.Date("2001-03-01"), "2001 (6.3%)", anchor="end") %>%
  sg_add_marker(x=as.Date("2007-12-01"), "2007 (10.1%)", anchor="end") %>%
  sg_annotate(label="Vermont", x=as.Date("1978-04-01"), y=0.6, color="#ffffff") %>%
  sg_annotate(label="Maine", x=as.Date("1978-03-01"), y=0.30, color="#ffffff") %>%
  sg_annotate(label="Nebraska", x=as.Date("1977-06-01"), y=0.41, color="#ffffff") %>%
  sg_annotate(label="Massachusetts", x=as.Date("1977-06-01"), y=0.36, color="#ffffff") %>%
  sg_annotate(label="New Hampshire", x=as.Date("1978-03-01"), y=0.435, color="#ffffff") %>%
  sg_annotate(label="California", x=as.Date("1978-02-01"), y=0.175, color="#ffffff") %>%
  sg_annotate(label="Rhode Island", x=as.Date("1977-11-01"), y=0.55, color="#ffffff") %>%
  sg_annotate(label="Ohio", x=as.Date("1978-06-01"), y=0.485, color="#ffffff") %>%
  sg_annotate(label="Connecticut", x=as.Date("1978-01-01"), y=0.235, color="#ffffff") %>%
  sg_fill_tableau() %>%
  sg_legend(show=TRUE)