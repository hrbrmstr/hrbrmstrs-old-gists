library(curl)
library(httr)
library(jsonlite)
library(parallel)

# MODIFY THESE VALUES IF NECESSARY ----------------------------------------

# parallel downlods
options(mc.cores=4)

base_url <- "https://czdap.icann.org"

# change this to your liking; get_zones() will make a new directory underneath
# this based on today's date
base_zone_dir <- "~/Data/zonefiles"

# store your key in this environment variable
api_key <- Sys.getenv("ICANN_CZDAP_KEY")

# functions ---------------------------------------------------------------

#' Retrieve the zone data urls available to the ICANN_CZDAP_KEY
#' @return character vector of URL paths with embedded api key
get_zone_data_urls <- function() {
  resp <- GET(base_url,
              path="user-zone-data-urls.json",
              query=list(token=api_key))
  stop_for_status(resp)
  fromJSON(content(resp, as="text"))
}


# called by get_zones() - downloads one zone file
get_zone <- function(zone_url, zone_dir, base_url) {
  fil <- paste0(file.path(path.expand(zone_dir), basename(parse_url(zone_url)$path)), ".txt.gz", collapse="")
  URL <- sprintf("%s%s", base_url, zone_url)
  download.file(URL, fil, mode="wb", quiet=TRUE)
}


#' Download all zone files associated with ICANN_CZDAP_KEY.
#'
#' Works in parallel (set \code{options(mc.cores=###)}).
#'
#' @param zone_urls optional vector of partial URLs to download
get_zones <- function(zone_urls=NULL) {

  if (length(zone_urls)==0) zone_urls <- get_zone_data_urls()

  message(sprintf("Downloading %d zone files...", length(zone_urls)))

  zone_dir <- sprintf("%s/%s", base_zone_dir, format(Sys.Date(), "%Y%m%d"))
  dir.create(zone_dir, showWarnings=FALSE, recursive=TRUE)

  invisible(mclapply(zone_urls, get_zone, zone_dir=zone_dir, base_url=base_url))

}

# Get all the zone files --------------------------------------------------

get_zones()
