hour = {
  html_nodes(pg$result, xpath=".//div[contains(@class, 'list-title-w')]") %>% 
  html_attr("id") %>%
  map2(1:length(.), ~{
    html_nodes(
      pg$result,
      xpath =
        sprintf(".//*/div[@id='%s']/following-sibling::div[contains(@class, 'item-row') and
         count(preceding-sibling::div[contains(@class, 'list-title-w')])=%s]", .x, .y)
    ) -> nod
    rep(as.numeric(.x), length(nod))
  }) %>% flatten_chr() }