library(xml2)
library(purrr)

fil <- "https://gist.githubusercontent.com/hrbrmstr/f9c3bbc561e824219954ab5eecc12f2b/raw/65dad652d575b9c475559cbed86fceb5f0ff4d1b/books.xml"
doc <- read_xml(fil)

i <- 1
walk(xml_find_all(doc, "//book"), function(x) {
  writeLines(as.character(x), sprintf("out-%03d.xml", i))
  i <<- i + 1
})
