library(httr)
library(magick)
library(hrbrthemes)
library(ggplot2)

theme_tweet_rc <- function(grid = "XY", style = c("stream", "card"), retina=TRUE) {
  
  style <- match.arg(tolower(style), c("stream", "card"))
  
  switch(
    style, 
    stream = c(24, 18, 16, 14, 12),
    card = c(22, 16, 14, 12, 10)
  ) -> font_sizes
  
  theme_ipsum_rc(
    grid = grid, 
    plot_title_size = font_sizes[1], 
    subtitle_size = font_sizes[2], 
    axis_title_size = font_sizes[3], 
    axis_text_size = font_sizes[4], 
    caption_size = font_sizes[5]
  )
  
}

gg_tweet <- function(g, status = "ggplot2 image", style = c("stream", "card"), retina=TRUE,
                     send = FALSE) {
  
  style <- match.arg(tolower(style), c("stream", "card"))
  
  switch(
    style, 
    stream = c(w=1024, h=512),
    card = c(w=800, h=320)
  ) -> dims
  
  dims["res"] <- 72
  
  if (retina) dims <- dims * 2
  
  fig <- image_graph(width=dims["w"], height=dims["h"], res=dims["res"])
  print(g)
  dev.off()
  
  if (send) {
    
    message("Posting image to twitter...")
    
    tf <- tempfile(fileext = ".png")
    image_write(fig, tf, format="png")
    
    # Create an app at apps.twitter.com w/callback URL of http://127.0.0.1:1410
    # Save the app name, consumer key and secret to the following
    # Environment variables
    
    app <- oauth_app(
      appname = Sys.getenv("TWITTER_APP_NAME"),
      key = Sys.getenv("TWITTER_CONSUMER_KEY"),
      secret = Sys.getenv("TWITTER_CONSUMER_SECRET")
    )
    
    twitter_token <- oauth1.0_token(oauth_endpoints("twitter"), app)
    
    POST(
      url = "https://api.twitter.com/1.1/statuses/update_with_media.json",
      config(token = twitter_token), 
      body = list(
        status = status,
        media = upload_file(path.expand(tf))
      )
    ) -> res
    
    warn_for_status(res)
    
    unlink(tf)
    
  }
  
  fig
  
}

ggplot(mtcars, aes(wt, mpg)) + 
  geom_point() +
  labs(
    title = "Yet-another mtcars plot",
    subtitle = "With an equally boring subtitle",
    caption = "Source: ggplot2"
  ) +
  theme_tweet_rc(grid="XY", retina=TRUE) -> gg

gg_tweet(gg, status = "", send = TRUE, retina = TRUE)

