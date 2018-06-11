library(tidyverse)

guns_orig <- read_csv("https://docs.google.com/spreadsheet/pub?key=0AswaDV9q95oZdG5fVGJTS25GQXhSTDFpZXE0RHhUdkE&output=csv")

guns <- janitor::clean_names(guns_orig)
guns <- separate(guns, location, c("city", "state"), sep=",")
guns <- mutate(guns, city = trimws(city))
guns <- mutate(guns, state = trimws(state))
guns <- mutate(guns, state = str_replace_all(state, "\\.", ""))

left_join(
  guns,
  data_frame(
    abb = state.abb,
    state_name = state.name
  ),
  by = c("state"="state_name")
) %>% 
  mutate(abb = ifelse(is.na(abb), state, abb)) %>%
  select(-state) %>% 
  rename(state = abb) 
