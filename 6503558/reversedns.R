# "dig" needs to be on your system and in the execution path for this to work
resolved = sapply(ip.list, function(x) system(sprintf("dig -x %s +short",x), intern=TRUE))
