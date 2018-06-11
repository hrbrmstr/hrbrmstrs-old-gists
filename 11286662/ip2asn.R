# yes, this (dyn.load) is all it takes to expose the function we 
# just created to R. and, yes, it's a bit more complicated than
# that, but for now bask in the glow of simplicity

dyn.load("txt.so")

# this function should look more than vaguely familiar
# http://dds.ec/blog/posts/2014/Apr/firewall-busting-asn-lookups/

ip2asn <- function(ip="216.90.108.31") {

  orig <- ip

  ip <- paste(paste(rev(unlist(strsplit(ip, "\\."))), sep="", collapse="."), 
              ".origin.asn.cymru.com", sep="", collapse="")

  # in essence, we replaced the `system("dig ...")` call with this

  result <- .Call("txt", ip)

  out <- unlist(strsplit(gsub("\"", "", result), "\ *\\|\ *"))

  return(list(ip=orig, asn=out[1], cidr=out[2], cn=out[3], registry=out[4]))

}