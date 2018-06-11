#' @param search_terms
#' @param other parameters passed to httr GET/POST request
#' @return data.frame of results
search_now <- function(search_terms, ...) {

  require(httr)

  # i.e. "https://localhost:8089"
  splunk_server <- Sys.getenv("SPLUNK_API_SERVER")
  username <- Sys.getenv("SPLUNK_USERNAME")
  password <- Sys.getenv("SPLUNK_PASSWORD")

  search_job_export_endpoint <- "servicesNS/admin/search/search/jobs/export"

  response <- GET(splunk_server,
                   path=search_job_export_endpoint,
                   encode="form",
                   config(ssl_verifyhost=FALSE, ssl_verifypeer=0),
                   authenticate(username, password),
                   query=list(search=paste0("search ", search_terms, collapse="", sep=""),
                              output_mode="csv"),
                   verbose(), ...)

  result <- read.table(text=content(response, as="text"), sep=",", header=TRUE,
                       stringsAsFactors=FALSE)

  result

}
