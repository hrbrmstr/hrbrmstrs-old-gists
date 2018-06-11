library(crafter)
library(dplyr)

ncap <- read_pcap(system.file("pcaps/Ncapture.pcap", package="crafter"))

ncap_tcp %>% 
  filter(syn==TRUE & fin==FALSE & rst==FALSE & rst==FALSE & psh==FALSE & 
           ack==FALSE & urg==FALSE & ece==FALSE & cwr==FALSE) %>% 
  select(num, src, dst, srcport, dstport) -> convo_starts

# change "1" to other conversation start #'s
convo <- data.frame(convo_starts[1,], stringsAsFactors=FALSE)

ncap_tcp %>% 
  filter(((src==convo$src | src==convo$dst) &
          (dst==convo$dst | dst==convo$src)) &
          ((srcport==convo$srcport & dstport==convo$dstport) |
           (srcport==convo$dstport & dstport==convo$srcport))) %>% 
  select(-payload)


