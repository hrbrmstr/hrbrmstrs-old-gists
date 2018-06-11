library(httr)
library(jsonlite)

# pkg -------------------------------------------------------------------------------

platform <- "CRAN"
pkg_name <- "ggplot2"

res <- GET(sprintf("https://libraries.io/api/%s/%s", platform, pkg_name),
           query=list(api_key=Sys.getenv("LIBRARIES_IO_API_KEY")))

fromJSON(content(res, as="text"))

# pkd deps --------------------------------------------------------------------------

platform <- "CRAN"
pkg_name <- "tidyr"
pkg_version <- "latest"

res <- GET(sprintf("https://libraries.io/api/%s/%s/%s/dependencies", 
                   platform, pkg_name, pkg_version),
           query=list(api_key=Sys.getenv("LIBRARIES_IO_API_KEY")))

fromJSON(content(res, as="text"))

# gh proj ---------------------------------------------------------------------------

gh_owner <- "hrbrmstr"
gh_name <- "ggalt"

res <- GET(sprintf("https://libraries.io/api/github/%s/%s", gh_owner, gh_name),
           query=list(api_key=Sys.getenv("LIBRARIES_IO_API_KEY")))

fromJSON(content(res, as="text"))

# gh deps ---------------------------------------------------------------------------

res <- GET(sprintf("https://libraries.io/api/github/%s/%s/dependencies", gh_owner, gh_name),
           query=list(api_key=Sys.getenv("LIBRARIES_IO_API_KEY")))

fromJSON(content(res, as="text"))

# gh proj ---------------------------------------------------------------------------

gh_owner <- "hadley"
gh_name <- "dplyr"

res <- GET(sprintf("https://libraries.io/api/github/%s/%s/projects", gh_owner, gh_name),
           query=list(api_key=Sys.getenv("LIBRARIES_IO_API_KEY")))

fromJSON(content(res, as="text"))

# gh user ---------------------------------------------------------------------------

gh_owner <- "hrbrmstr"

res <- GET(sprintf("https://libraries.io/api/github/%s", gh_owner),
           query=list(api_key=Sys.getenv("LIBRARIES_IO_API_KEY")))

fromJSON(content(res, as="text"))

# gh user repos ---------------------------------------------------------------------

gh_owner <- "hrbrmstr"

res <- GET(sprintf("https://libraries.io/api/github/%s/repositories", gh_owner),
           query=list(api_key=Sys.getenv("LIBRARIES_IO_API_KEY")))

fromJSON(content(res, as="text"))



