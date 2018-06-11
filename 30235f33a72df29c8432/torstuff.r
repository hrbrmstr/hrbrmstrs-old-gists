is_tor_exit_node <- function(x, refresh=FALSE) {
  require(purrr)
  require(stringi)
  if (!file.exists("tor-exit-addresses.rda") | refresh) {
    download.file("https://check.torproject.org/exit-addresses", 
                  "exit-addresses.txt")
    tor_exits <- grep("ExitAddress", readLines("exit-addresses.txt"), value=TRUE)
    tor_exits <- gsub("ExitAddress ", "", tor_exits)
    tor_exits <- stri_split_fixed(tor_exits, " ", 2)
    tor_exits <- map_df(tor_sep, function(x) {
      data.frame(ip=x[1], 
                 ts=as.POSIXct(x[2]), 
                 stringsAsFactors=FALSE)
    })
    save(tor_exits, file="tor-exit-addresses.rda")
  }
  load("tor-exit-addresses.rda")
  x %in% tor_exits$ip
}

is_tor_node <- function(x, refresh=FALSE) {
  if (!file.exists("tornodes.rda") | refresh) {
    download.file("https://www.dan.me.uk/torlist/", 
                  "tornodes.txt")
    tor_nodes <- readLines("tornodes.txt")
    save(tor_nodes, file="tornodes.rda")
  }
  load("tornodes.rda")
  x %in% tor_nodes
}

is_tor_exit_node("216.245.218.190")
is_tor_node("216.245.218.190")

