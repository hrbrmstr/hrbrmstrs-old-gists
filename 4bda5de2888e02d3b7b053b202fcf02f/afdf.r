#' Flatten data frames in a tested list into a single depth lis
#'
#' @param x a `list`
flatten_dfs <- function(x) {

  res <- list()

  n <- length(x)

  if (length(n) == 0) return

  for (i in 1:n) {                       # 
    if (is.data.frame(x[[i]])) {         # if it's a data frame accumulate it
      res <- append(res, list(x[[i]]))
    } else {                             # other wise recurse
      if (is.list(x[[i]])) res <- append(res, flatten_dfs(x[[i]]))
    }
  }

  return(res)

}