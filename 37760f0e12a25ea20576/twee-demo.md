# twee demo
Jenny Bryan  
17 August, 2014  

The Linux [`tree` command](http://mama.indstate.edu/users/ice/tree/) spits out a plain text listing of a directory.

I've often wanted this in R markdown documents, especially for exposition. While I realize the full-fledged `tree` command is just a `brew install tree` away for *me* ... I want these documents to be easy for my *students* to compile. I wanted a plain R solution.

The `twee()` function is a first attempt at this. It's got a whopping two arguments:

  * `path` the directory to list; defaults to working directory
  * `level` how deep to list; defaults to `Inf`, i.e. as deep as it goes
  
#### Basic `twee()` demo

I create some files, tucked down in subdirectories.


```r
jfile <- "example"
writeLines(c("line 1", "line 2"), jfile)
dir.create("foo/this/is/an", recursive = TRUE)
file.copy(jfile, "foo/this/is/an")
## [1] TRUE
dir.create("foo/this/is/another/super/nested", recursive = TRUE)
file.copy(jfile, "foo/this/is/another/super/nested")
## [1] TRUE
```

Source the `twee()` function! (*Source given below and in [this Gist file](https://gist.github.com/jennybc/2bf1dbe6eb1f261dfe60#file-twee-r).*)


```r
source("twee.R")
```

List the directory `foo`:


```r
twee("foo")
```

```
-- this
   |__is
      |__an
         |__example
      |__another
         |__super
            |__nested
               |__example
```

Note: the call `twee()`, with no arguments at all, will just list current working directory.

Let's clean up.


```r
unlink(c("foo", "example"), recursive = TRUE)
```

#### Demo the `level` argument

Create some more files:


```r
jfile <- "file"
writeLines(c("line 1", "line 2"), jfile)
dir.create("foo/level-01-dir/level-02-dir", recursive = TRUE)
file.copy(jfile, "foo/level-01-file")
## [1] TRUE
file.copy(jfile, "foo/level-01-dir/level-02-file")
## [1] TRUE
file.copy(jfile, "foo/level-01-dir/level-02-dir/level-03-file")
## [1] TRUE
```

List the directory `foo` with default `level = Inf` to see all the things:


```r
twee("foo")
```

```
-- level-01-dir
   |__level-02-dir
      |__level-03-file
   |__level-02-file
-- level-01-file
```

And again, listing only down to `level = 2`:


```r
twee("foo", level = 2)
```

```
-- level-01-dir
   |__level-02-dir
   |__level-02-file
-- level-01-file
```

Clean up.


```r
unlink(c("foo", "file"), recursive = TRUE)
```

#### Things I could do

  * validity check of args
  * refactor it? the one-line inspiration suggests there are much more clever regexp-y ways to do this ... but that's so hard to read :(
  * implement other [options of `tree`](http://mama.indstate.edu/users/ice/tree/tree.1.html), especially
    - `-F` to distinguish, e.g. directories
    - `-P` and `-I` for including/excluding based on pattern
    - `--filelimit #` to cope with directories populated with tons of files
  * make my display more similar to that of `tree` and friends
  * output valid Markdown? (I note that `tree` can output XML and HTML ... so maybe that's a sign it's time to use `tree` itself!)

#### `twee()` source


```
## quick-and-dirty ersatz Unix tree command in R
## inspired by this one-liner:
## ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
## found here (among many other places):
## http://serverfault.com/questions/143954/how-to-generate-an-ascii-representation-of-a-unix-file-hierarchy

twee <- function(path = getwd(), level = Inf) {
  
  fad <-
    list.files(path = path, recursive = TRUE,no.. = TRUE, include.dirs = TRUE)

  fad_split_up <- strsplit(fad, "/")

  too_deep <- lapply(fad_split_up, length) > level
  fad_split_up[too_deep] <- NULL
  
  jfun <- function(x) {
    n <- length(x)
    if(n > 1)
      x[n - 1] <- "|__"
    if(n > 2)
      x[1:(n - 2)] <- "   "
    x <- if(n == 1) c("-- ", x) else c("   ", x)
    x
  }
  fad_subbed_out <- lapply(fad_split_up, jfun)
  
  cat(unlist(lapply(fad_subbed_out, paste, collapse = "")), sep = "\n")
}
```

