Rcpp::cppFunction('int rcpp_find2(NumericVector needle, NumericVector haystack) {
  NumericVector::iterator it;
  it = std::search(haystack.begin(), haystack.end(), needle.begin(), needle.end());
  int pos = it - haystack.begin() + 1;
  if (pos > haystack.size()) pos = -1;
  return(pos);
}')


set.seed(010)
haystack <- sample(0:12, size = 2000, replace = TRUE)
needle   <- c(2L, 0L, 9L) 

microbenchmark::microbenchmark(rcpp_find2(needle, haystack))
