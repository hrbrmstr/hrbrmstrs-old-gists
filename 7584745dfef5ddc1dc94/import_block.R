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