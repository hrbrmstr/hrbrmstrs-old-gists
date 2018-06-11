as_tribble <- function(x) {
  
  out <- capture.output(write.csv(x, quote=TRUE, row.names=FALSE))
  out[1] <- gsub('"', '`', out[1])
  out[1] <- sub('^`', "  ~`", out[1])
  out[1] <- gsub(',`', " , ~`", out[1])
  out <- paste0(out, collapse=",\n  ")
  cat(sprintf("tribble(\n%s\n)", out, ")\n"))

}

as_tribble(head(mtcars))
