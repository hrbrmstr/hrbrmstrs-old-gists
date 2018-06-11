library(Rcpp)

sourceCpp("dns.cpp")

getAddrInfo("74.125.226.66")
getNameInfo("google.com")
