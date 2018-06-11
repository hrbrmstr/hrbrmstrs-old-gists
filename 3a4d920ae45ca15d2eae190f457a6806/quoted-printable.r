purrr::map(c(0:9, LETTERS[1:6]), function(x) {
  purrr::map_chr(c(0:9, LETTERS[1:6]), function(y) {
    sprintf("=%s%s", x, y)
  })
}) %>% flatten_chr() %>% dput()

purrr::map(c(0:9, LETTERS[1:6]), function(x) {
  purrr::map_chr(c(0:9, LETTERS[1:6]), function(y) {
    URLdecode(sprintf("%%%s%s", x, y))
  })
}) %>% flatten_chr() %>% dput()
