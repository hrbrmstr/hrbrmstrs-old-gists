### Livecoding D3 in RStudio

This is a proof-of-concept on how one can use RStudio to livecode D3 visualizations.

##### Usage

You will need to install a couple of packages before getting started

```r
devtools::install_github("yihui/servr")
install.packages("downloader")
```

I wrote a quick-and-dirty `import_block` function that downloads the gist, unzips it to a folder, and serves it using the `servr` package. Thanks to @yihui for writing a new function `httw` that watches for changes to a directory and livereloads the html file if it detects any.

```r
#' Import a block and serve it up locally for live-editing
#' 
#' @param gistId id of the block
#' @param dir directory to download the block to
#' @param edit boolean indicating whether to serve index.html for live-editing
#' @param ... other arguments to pass to servr::httw()
#' 
#' @examples 
#' import_block("4b66c0d9be9a0d56484e")
import_block <- function(id, dir = NULL, edit = TRUE, ...){
  url <- paste0("http://gist.github.com/", id, "/download")
  if (is.null(dir)) td <- tempdir() else td = dir
  cwd = getwd(); setwd(td); on.exit(setwd(cwd))
  downloader::download(url, destfile = paste0(id, '.zip'), mode = 'wb')
  unzip(file.path(td, paste0(id, '.zip')), junkpaths = FALSE)
  dir <- list.files(pattern = paste0(id, "-"))[1]
  if (edit){
    file.edit(file.path(dir, 'index.html'))
    on.exit(unlink(paste0(id, '.zip')))
    servr::httw(dir, ...)
  } else {
    message("Downloaded gist ", gistId, 'to ', dir)
    message("Switch to ", dir, " and run servr::httw() to live edit")
  }
}
```

To get started, just pick your favorite block to work with and run `import_block(id = "4b66c0d9be9a0d56484e")`. If you dont specify an explicit directory, then `import_block` will save it to a temporary folder. This is useful if you want to quickly play with a block.

