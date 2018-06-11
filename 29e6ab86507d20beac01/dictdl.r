library(rvest)

base <- "http://www.textcontrol.com"
URL <- "http://www.textcontrol.com/en_US/downloads/dictionaries/"

pg <- read_html(URL)

dicts <- sprintf("%s%s", base, html_attr(html_nodes(pg, "a[href^='/downloads/dictionaries/']"), "href"))

td <- tempdir()

for (dict in dicts) {
  download.file(dict, sprintf("%s/%s", td, basename(dict)))
}

for (f in list.files(td, pattern = "hyph_.*dic", 
                     recursive=TRUE, full.names=TRUE)) {
  cat(f)
  file.copy(f, "inst/extdata/dicts/")
}
