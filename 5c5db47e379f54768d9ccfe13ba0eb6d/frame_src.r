library(rvest)

pg <- read_html("http://www.ons.org.br/resultados_operacao/boletim_semanal/2016_12_16/ena.htm")

actual_page <- html_nodes(pg, "frameset > frame[name='frSheet']") %>% html_attr("src")
pg <- read_html(sprintf("http://www.ons.org.br/resultados_operacao/boletim_semanal/2016_12_16/%s", actual_page))

html_nodes(pg, xpath=".//td[not(@colspan) and starts-with(@class, 'xl7')]") %>% 
  html_text() %>% 
  matrix(ncol=3, byrow=TRUE) %>% 
  as.data.frame(stringsAsFactors=FALSE) %>% 
  docxtractr::assign_colnames(1) %>% 
  readr::type_convert() %>% 
  dplyr::tbl_df()
