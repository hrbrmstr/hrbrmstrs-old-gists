library(tidyverse)

c("115p7UMMngoj1pMvkpHijcRdfJNXj6LrLn",
  "12t9YDPgwueZ9NyMgw519p7AA8isjr6SMw", 
  "13AM4VW2dhxYgXeQepoHkHSQuy6NgaEb94") %>% 
  sprintf("https://blockchain.info/rawaddr/%s", .) %>% 
  map(jsonlite::fromJSON) -> chains

map_dbl(chains, "total_received") %>% map_dbl(`/`, 10e7) %>% sum()

map_dbl(chains, ~nrow(.$txs)) %>% sum()
