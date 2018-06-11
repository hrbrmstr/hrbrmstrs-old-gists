library(tidyverse)

guns_orig <- read_csv("https://docs.google.com/spreadsheet/pub?key=0AswaDV9q95oZdG5fVGJTS25GQXhSTDFpZXE0RHhUdkE&output=csv")

janitor::clean_names(guns_orig) %>% 
  separate(location, c("city", "state"), sep=",") %>% # separate city and state into two fields by comma
  mutate(city = trimws(city)) %>% # remove leftover whitepace
  mutate(state = trimws(state)) %>% 
  mutate(state = str_replace_all(state, "\\.", "")) %>% # get rid of periods
  left_join( # try to make a normalized abbreviated state column
    data_frame(
      abb = state.abb,
      state_name = state.name
    ),
    by = c("state"="state_name")
  ) %>% 
  mutate(abb = ifelse(is.na(abb), state, abb)) %>%
  select(-state) %>% 
  rename(state = abb) %>% 
  mutate(date = lubridate::mdy(date)) %>% # make the data a date 
  mutate(total_victims = str_replace_all(total_victims, "[^[:digit:]]", "")) %>% # make total victims numeric
  mutate(total_victims = as.integer(total_victims)) %>%
  mutate(venue = trimws(tolower(venue))) %>% # normalize venue
  mutate(race = trimws(tolower(race))) %>% # normalize race
  mutate(gender = trimws(tolower(gender))) %>% # clean up/normalize gender
  mutate(gender = str_replace(gender, "male", "m")) %>% 
  mutate(gender = str_replace(gender, "fe.*", "f")) %>% 
  mutate(used_rifle = str_detect(type_of_weapons, fixed("rifle", ignore_case=TRUE))) %>% # rifle used?
  mutate(used_handgun = str_detect(type_of_weapons, regex("handgun|revolv|derringer", ignore_case=TRUE))) %>% # handgun used?
  mutate(used_knife = str_detect(type_of_weapons, fixed("kni", ignore_case=TRUE))) %>% # knife used?
  mutate(used_shotgun = str_detect(type_of_weapons, fixed("shotgun", ignore_case=TRUE))) %>% # shotgun used?
  mutate(semiauto_used = str_detect(type_of_weapons, fixed("semi", ignore_case=TRUE))) %>% # semi-auto guns used?
  mutate(assault_style = str_detect(type_of_weapons, fixed("assau", ignore_case=TRUE))) %>%  # assault-style weaopns used? 
  mutate(ar15_used = str_detect(type_of_weapons, fixed("AR[-]*15", ignore_case=TRUE))) %>%
  mutate(ak47_used = str_detect(type_of_weapons, fixed("AK[-]*47", ignore_case=TRUE))) 
