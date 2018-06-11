library(httr)

read.csv(textConnection(content(GET(gap_data[1,]$link), as="text")), stringsAsFactors=FALSE)
