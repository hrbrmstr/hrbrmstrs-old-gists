echo <- function(...) {
  
  bits <- list(...)
  
  for (i in seq_along(bits)) {
    print(sprintf(">> %s", toString(bits[[i]])))
  }
  
}

echo("hello")
echo("hello", "world")
echo("four score and seven years ago")

words <- c("four", "score", "and", "seven", "years", "ago")

echo(words)

do.call(echo, as.list(words))
