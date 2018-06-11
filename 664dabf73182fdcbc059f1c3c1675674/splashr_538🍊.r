library(splashr)

vm <- start_splash("localhost")

splash_local %>% 
  execute_lua('
function main(splash)
  splash:go("https://projects.fivethirtyeight.com/congress-trump-score/")
  splash:wait(0.5)
  return splash:evaljs("memberScores")
end
') -> res

rawToChar(res) %>% 
  jsonlite::fromJSON(flatten=TRUE) %>% 
  purrr::map(tibble::as_tibble) -> member_scores

member_scores

stop_splash(vm)
