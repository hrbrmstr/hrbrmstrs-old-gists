library(twitteR)
library(stringi)
library(gistr)
library(htmltools)

refresh_rstats <- function() {

  invisible(capture.output(
    setup_twitter_oauth(Sys.getenv("TWITTER_CONSUMER_KEY"),
                      Sys.getenv("TWITTER_CONSUMER_SECRET"),
                      Sys.getenv("TWITTER_ACCESS_TOKEN"),
                      Sys.getenv("TWITTER_ACCESS_SECRET"))))

  mute <- readLines(as.gist("c99ec8bbca9bbf2057b3")$files$mute.txt$raw_url)

  tweets <- searchTwitter("#rstats", n=100)

  tweet_text <- sapply(tweets, function(x) {
    sprintf("<b>@%s</b>: %s <a href='https://twitter.com/%s/status/%s'>↪</a>",
            x$screenName, stri_replace_all_regex(x$text,
                 "(#[[:alpha:]]+)", "<code>$1</code>"), x$screenName, x$id)
  })

  filtered_tweets <-
    suppressWarnings(tweet_text[which(!stri_detect_fixed(tweet_text, mute,
                    opts_fixed=stri_opts_fixed(case_insensitive=TRUE)))])

  out <- ""
  for (tweet in filtered_tweets) {
    out <- out %s+% sprintf("<li>%s</li>\n", tweet)
  }

  html_print(HTML(stri_encode(sprintf("<style>*{font-family:sans-serif}
code{font-family:monospace}
li{padding-bottom:10px}</style><h3>Latest #rstats tweets</h3><ul>\n%s</ul>",
                                      out))))

}

refresh_rstats()
