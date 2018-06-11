
```r
library(rvest)
```

### Plain


```r
res <- read_html("https://httpbin.org/user-agent")
cat(as.character(res))
```

```
## <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
## <html><body><p>{
##   "user-agent": "Google Bronze"
## }
## </p></body></html>
```

NOTE: 👆 My `~/.Rprofile` randomizes the `HTTPUserAgent` every restart.

### `with_config()` (This should work)


```r
res <- httr::with_config(httr::user_agent("blancmange"), { read_html("https://httpbin.org/user-agent") })
cat(as.character(res))
```

```
## <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
## <html><body><p>{
##   "user-agent": "Google Bronze"
## }
## </p></body></html>
```

### This works but only should if `curl`` is not availble


```r
options(HTTPUserAgent = "blancmange")
res <- read_html("https://httpbin.org/user-agent")
cat(as.character(res))
```

```
## <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
## <html><body><p>{
##   "user-agent": "blancmange"
## }
## </p></body></html>
```

### But it is


```r
print(requireNamespace("curl", quietly = TRUE))
```

```
## [1] TRUE
```

### Session


```r
devtools::session_info()
```

```
##  setting  value                       
##  version  R version 3.4.1 (2017-06-30)
##  system   x86_64, darwin15.6.0        
##  ui       X11                         
##  language (EN)                        
##  collate  en_US.UTF-8                 
##  tz       America/New_York            
##  date     2017-08-02                  
## 
##  package   * version    date       source                      
##  backports   1.0.5      2017-01-18 CRAN (R 3.4.0)              
##  curl        2.8.1      2017-08-02 Github (jeroen/curl@31d7e5b)
##  devtools    1.12.0     2016-12-05 CRAN (R 3.4.0)              
##  digest      0.6.12     2017-01-27 CRAN (R 3.4.0)              
##  evaluate    0.10       2016-10-11 CRAN (R 3.4.0)              
##  htmltools   0.3.6      2017-04-28 cran (@0.3.6)               
##  httr        1.2.1.9000 2017-08-02 Github (hadley/httr@b821613)
##  knitr       1.16       2017-05-18 cran (@1.16)                
##  magrittr    1.5        2014-11-22 CRAN (R 3.4.0)              
##  memoise     1.1.0      2017-04-21 cran (@1.1.0)               
##  R6          2.2.2      2017-06-17 cran (@2.2.2)               
##  Rcpp        0.12.12    2017-07-15 cran (@0.12.12)             
##  rmarkdown   1.6        2017-06-15 CRAN (R 3.4.0)              
##  rprojroot   1.2        2017-01-16 CRAN (R 3.4.0)              
##  rvest     * 0.3.2      2016-06-17 CRAN (R 3.4.0)              
##  stringi     1.1.5      2017-04-07 CRAN (R 3.4.0)              
##  stringr     1.2.0      2017-02-18 CRAN (R 3.4.0)              
##  withr       1.0.2      2016-06-20 CRAN (R 3.4.0)              
##  xml2      * 1.1.1      2017-01-24 CRAN (R 3.4.0)              
##  yaml        2.1.14     2016-11-12 cran (@2.1.14)
```


