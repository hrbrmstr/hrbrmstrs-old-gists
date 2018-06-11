purrr::map_df(2009:2014, function(i) {
  api_info <- jsonlite::fromJSON(sprintf("http://api.census.gov/data/%s/acs5/", i))
  api_info$dataset[, c("title", "c_unavailableMessage")]
})
