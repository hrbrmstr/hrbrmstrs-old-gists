refresh <- function(rm_emoji=TRUE) {

  suppressPackageStartupMessages(require(emo, quietly=TRUE, warn.conflicts=FALSE))
  suppressPackageStartupMessages(require(cli, quietly=TRUE, warn.conflicts=FALSE))
  suppressPackageStartupMessages(require(crayon, quietly=TRUE, warn.conflicts=FALSE))
  suppressPackageStartupMessages(require(rtweet, quietly=TRUE, warn.conflicts=FALSE))
  suppressPackageStartupMessages(require(tidyverse, quietly=TRUE, warn.conflicts=FALSE))

  start <- Sys.time()
  me <- get_my_timeline()

  arrange(me, created_at) %>%
    with(pwalk(list(created_at, screen_name, text), ~{
      diff <- sprintf(" [%4.2f hrs ago]", abs(round(as.numeric(anytime::anytime(..1) - start, "hours"), 2)))
      user <- sprintf("@%s ", ..2)
      tweet <- ..3
      if (rm_emoji) tweet <- emo::ji_replace_all(tweet, "")
      tweet <- paste0(strwrap(tweet, (console_width() - max(nchar(me$screen_name)) - 10)), collapse="\n  ")
      cat_bullet(green(user), cyan(tweet), silver(diff), "\n")
    }))

}
