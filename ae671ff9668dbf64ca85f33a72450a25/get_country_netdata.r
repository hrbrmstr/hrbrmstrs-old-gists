get_country_netdata <- function(iso2c){
  cc_url <- sprintf("https://stat.ripe.net/data/country-resource-list/data.json?resource=%s", iso2c)
  res <- jsonlite::fromJSON(cc_url)
  res
}
