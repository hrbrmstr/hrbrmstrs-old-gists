vprint <- function(x, ...) {
  require(htmltools)
  html_print(pre(paste0(capture.output(print(x, ...)), collapse="\n")))
}


vcat <- function(...) {
  require(htmltools)
  html_print(pre(paste0(capture.output(cat(...)), collapse="\n")))
}