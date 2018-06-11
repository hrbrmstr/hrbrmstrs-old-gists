library(reticulate)

# https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_string_search_algorithm#Implementations
bm <- py_run_file("~/Documents/Sandbox/BoyerMoore/boyermoor.py")

set.seed(1)
haystack <- sample(0:12, size = 2000, replace = TRUE)
needle   <- c(2L, 10L, 8L)

## the python implementation only searches _actual_ text, so convert to alphabet
## (update: LETTERS[0] does not exist)
n <- paste(LETTERS[needle + 1], collapse = "")
h <- paste(LETTERS[haystack + 1], collapse = "")

found <- bm$string_search(n, h)[1]
identical(n, substr(h, found + 1, found + 3)) ## FYI, these are 0-indexed
# TRUE

## my implementation
sieved_find <- function(needle, haystack) { 
  sieved <- which(haystack == needle[1L]) 
  for (i in seq.int(1L, length(needle) - 1L)) {
    sieved <- sieved[haystack[sieved + i] == needle[i + 1L]]
  }
  sieved[1L] 
}

microbenchmark::microbenchmark(
  bm$string_search(n, h)[1],
  sieved_find(needle, haystack),
  times = 1000
)
# Unit: microseconds
#                          expr     min      lq      mean   median      uq      max neval cld
#     bm$string_search(n, h)[1] 679.451 752.947 869.77227 803.2065 930.105 5190.839  1000   b
# sieved_find(needle, haystack)   8.573  11.833  17.30962  14.9680  20.185  154.544  1000  a 