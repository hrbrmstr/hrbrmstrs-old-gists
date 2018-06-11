mkpub <- function(who = "hrbrmstr", prj_name) {
  httr::PUT(
    url = sprintf("https://gitlab.com/api/v4/projects/%s%%2F%s", who, prj_name),
    query = list(
      visibility = "public",
      private_token = Sys.getenv("GITLAB_PAT")
    )
  ) -> res
  httr::content(res, as="parsed")
}

lsprj <- function(who = "hrbrmstr", pg = 1) {
  httr::GET(
    url = sprintf("https://gitlab.com/api/v4/users/%s/projects", who),
    query = list(
      visibility = "private",
      private_token = Sys.getenv("GITLAB_PAT"),
      per_page = 100,
      page = pg
    )
  ) -> res
  httr::content(res, as="parsed")
} 