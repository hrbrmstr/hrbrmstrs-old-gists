library(iptools)
library(tidyverse)

data_frame(
  rank = 134:145,
  dns = c("cloudflare.com", "youtubei.youtube.com", "static.xx.fbcdn.net",
          "bidswitch.net", "mail.google.com", "xp.apple.com", "sb.scorecardresearch.com",
          "x.bidswitch.net", "settings.crashlytics.com", "a.akamaiedge.net", 
          "googleads4.g.doubleclick.net", "adobe.com"),
  date = "20170425"
) -> apr

mutate(apr, ip_address = map_chr(hostname_to_ip(dns), 1))