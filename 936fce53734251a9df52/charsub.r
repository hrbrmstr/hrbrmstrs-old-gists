library(inline)
library(stringi)

#' Replace a substring of a string
#' 
#' @param str string the source string that you want to replace characters in
#'            (a character vector of length 1)
#' @param repl another string (this will be copied into \code{str})
#' @param pos position of the first character to be replaced
#' @param len number of characters to replace (if the string is shorter,
#'        as many characters as possible are replaced).
#' @examples
#' src <- "The quick brown fox"
#' 
#' charsub(src, "slow", 5, 5)
#' ## [1] "The slow brown fox"
#' 
#' charsub(src, "", 1, 4)
#' ## [1] "quick brown fox"
#' 
#' charsub(src, "t", 1, 1)
#' ## [1] "the quick brown fox"
strsub <- cxxfunction(signature(str="character", repl="character",
                                pos="integer", len ="integer"), '
  std::string x = as<std::string>(str);
  std::string y = as<std::string>(repl);
  x.replace(as<int>(pos)-1, as<int>(len), y);
  return(wrap(x));
', plugin = "Rcpp", includes=c("#include <iostream>",
                               "#include <string>"))

x2 <- c("apple", "banana", "orange", "pineapple", "kiwi")

#' Replace characters in a character vector
#' 
#' Given a vector of strings, this function will replace the 
#' character at postion \code{pos} with it's counterpart in \code{repl}.
#' 
#' If the replacement position is greater than the legnth of the associated
#' \code{src} string, \code{src} will be padded right with spaces before
#' performing the "substitution".
#' 
#' @note \code{src}, \code{pos} and \code{repl} must be the same vector length
#'
#' @param src character vector
#' @param pos integer vector specifying individual character position 
#'        in \code{src} to replace
#' @param repl character vector of single-character replacements to put at 
#'        \code{pos}
charsub <- function(src, pos, repl) {
  
  vapply(src, function(SRC) {
    s_len <- nchar(SRC)
    for (i in 1:length(pos)) {
      r_len <- nchar(repl[i])
      if ((pos[i] + r_len) > s_len) {
        SRC <- stri_pad_right(SRC, (pos[i] + r_len) - 1) 
      }
      SRC <- strsub(SRC, repl[i], pos[i], r_len)
    }
    SRC
  }, character(1), USE.NAMES=FALSE)
  
}

charsub(x2, c(1, 7), c("X", "Y"))
