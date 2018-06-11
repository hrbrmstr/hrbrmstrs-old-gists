library(RSelenium)
library(rvest)

checkForServer()
startServer()
remDr <- remoteDriver()
remDr$open()

remDr$navigate("http://rud.is/b")
pg_1 <- remDr$getPageSource()

remDr$navigate("http://stackoverflow.com/")
pg_2 <- remDr$getPageSource()

remDr$close()
