library(httr)

oauth_app(
  appname = "wordpress",
  key = Sys.getenv("WORDPRESS_API_KEY"),
  secret = Sys.getenv("WORDPRESS_API_SECRET")
) -> wordpress_app

oauth_endpoint(
  base_url = "https://public-api.wordpress.com/oauth2",
  request = "authenticate",
  authorize = "authorize",
  access = "token"
) -> wordpress_endpoint

oauth2.0_token(
  wordpress_endpoint,
  wordpress_app,
  user_params = list(
    grant_type = "authorization_code",
    response_type = "code",
    scope = "global"
  ),
  cache = FALSE
) -> wordpress_token

# NOTE: API calls requiring authorization need to use something akin to:
#
#   add_headers(`Authorization` = sprintf("Bearer %s", wordpress_token$credentials$access_token))
#
# to provide the API token