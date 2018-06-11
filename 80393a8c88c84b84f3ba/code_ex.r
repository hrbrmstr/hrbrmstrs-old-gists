fil <- list.files("man", full.names=TRUE)

cat(sapply(fil, function(x) {
  rd <- tools::parse_Rd(x)
  ex <- rd[devtools:::rd_tags(rd) == "examples"]
  trimws(paste0(devtools:::process_ex(ex, run=FALSE), sep="", collapse="\n"))
}, USE.NAMES=FALSE))

