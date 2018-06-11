
library(curl)

# Get dir listing ---------------------------------------------------------

list_h <- new_handle()
handle_setopt(list_h, userpwd=userpw, ftp_use_epsv=TRUE, dirlistonly=TRUE)
con <- curl(url, "r", handle=list_h)
protocol <- readLines(con)
close(con)

# Save off a list of the filenames ----------------------------------------

writeLines(protocol, con="names.txt")

# Filter out only .zip files ----------------------------------------------

just_zips <- grep("\\.zip$", protocol, value=TRUE)

# Download the files ------------------------------------------------------

dl_h <- new_handle()
handle_setopt(dl_h, userpwd=userpw, ftp_use_epsv=TRUE)
for (i in seq_along(just_zips)) {
  curl_fetch_disk(url=sprintf("%s%s", url, just_zips[i]),
                  path=sprintf("/tmp/%s", just_zips[i]),
                  handle=dl_h)
}
