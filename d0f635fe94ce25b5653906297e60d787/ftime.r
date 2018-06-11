library(curl)
library(Rcpp)
library(inline)

h <- new_handle()
handle_setopt(h, filetime=TRUE, verbose=TRUE)
h <- curl_fetch_disk("ftp://ftp.ngdc.noaa.gov/STP/SOLAR_DATA/AIRGLOW/IGYDATA/abst5270",
                      "abst5270", h)
h

set_modtime <- rcpp(sig=c(path="character", ts="integer"), body=
" struct stat f_stat;
  struct utimbuf ftp_time;
  std::string file_path = as<std::string>(path);
  long file_ts = as<long>(ts);
  if (stat(file_path.c_str(), &f_stat) >= 0) {
    ftp_time.actime = f_stat.st_atime;
    ftp_time.modtime = file_ts;
    utime(file_path.c_str(), &ftp_time);
  }
", includes=c("#include <time.h>", "#include <utime.h>", "#include <sys/stat.h>"))




set_modtime("abst5270", as.numeric(h$modified))
set_modtime("abst5270", as.numeric(Sys.time()))

