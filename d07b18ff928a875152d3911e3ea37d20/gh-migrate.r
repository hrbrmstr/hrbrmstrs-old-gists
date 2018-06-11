gh_migrate("YOUR_GITHUB_USERNAME", "GITHUB_REPO")

gitea_user <- function(gitea_username, 
                       api_endpoint = Sys.getenv("GITEA_BASE_URL"),
                       gitea_token = Sys.getenv("GITEA_PAT")) {
    
  require("httr", quietly = TRUE)
  require("jsonlite", quietly = TRUE)
  
  httr::GET(
    url = api_endpoint, 
    path = sprintf("api/v1/users/%s", gitea_username),
    query = list(
      access_token = gitea_token
    ),
    verbose()
  ) -> res
  
  httr::warn_for_status(res)
  
  if (httr::status_code(res) %in% c(200, 201)) {
    out <- httr::content(res, as="text")
    out <- jsonlite::fromJSON(out)
    print(str(out))
    invisible(out)
  }

}

gh_migrate <- function(gh_user, gh_repo, repo_name = gh_repo, 
                       uid = 1, # use gitea_user() to find this out
                       description = gh_repo,
                       mirror = TRUE,
                       private = FALSE,
                       api_endpoint=Sys.getenv("GITEA_BASE_URL"), 
                       gitea_token=Sys.getenv("GITEA_PAT")) {
  
  require("httr", quietly = TRUE)
  require("jsonlite", quietly = TRUE)
  
  httr::POST(
    url = api_endpoint, 
    path = "api/v1/repos/migrate",
    encode = "json",
    body = list(
      auth_password = NULL,
      auth_username = NULL,
      clone_addr =  sprintf("git://github.com/%s/%s.git", gh_user, gh_repo),
      description = description,
      mirror = mirror,
      private = private,
      repo_name = gh_repo,
      uid = uid
    ),
    query = list(
      access_token = gitea_token
    )
  ) -> res
  
  httr::warn_for_status(res)
  
  if (!(httr::status_code(res) %in% c(200, 201))) {
    out <- httr::content(res, as="text")
    out <- jsonlite::fromJSON(out)
    cat(out$message)
  }
  
}


