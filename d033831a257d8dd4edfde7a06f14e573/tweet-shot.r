tweet_shot("947082036019388416")
# or tweet_shot("https://twitter.com/jhollist/status/947082036019388416")

tweet_shot <- function(statusid_or_url, zoom=3) {

  require(glue)
  require(rtweet)
  require(magick)
  require(webshot)

  x <- statusid_or_url[1]

  is_url <- grepl("^http[s]://", x)

  if (is_url) {

    is_twitter <- grepl("twitter", x)
    stopifnot(is_twitter)

    is_status <- grepl("status", x)
    stopifnot(is_status)

    already_mobile <- grepl("://mobile\\.", x)
    if (!already_mobile) x <- sub("://twi", "://mobile.twi", x)

  } else {

    x <- rtweet::lookup_tweets(x)
    stopifnot(nrow(x) > 0)
    x <- glue_data(x, "https://mobile.twitter.com/{screen_name}/status/{status_id}")

  }

  tf <- tempfile(fileext = ".png")
  on.exit(unlink(tf), add=TRUE)

  webshot(url=x, file=tf, zoom=zoom)

  img <- image_read(tf)
  img <- image_trim(img)

  if (zoom > 1) img <- image_scale(img, scales::percent(1/zoom))

  img

}
