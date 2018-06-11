spell_check <- function(rmd) {
  utils::aspell(rmd, knitr::knit_filter, control="-H -t")
}

count_words <- function(rmd) {
  qdap::word_count(paste(knitr::knit_filter(rmd), collapse=" "))
}

# "inconsiderate" check
# http://alexjs.com/
# npm install -g alex
alex <- function(rmd) {
  suppressWarnings(out <- system2("alex", args="-", input=knitr::knit_filter(rmd), stdout=TRUE))
  cat(out, sep="\n")
}
