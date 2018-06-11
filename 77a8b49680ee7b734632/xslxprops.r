#' Set Excel (xlsx) document properties
#'
#' pass in a named vector. Names should be in this set:
#'
#'   "dc:title", "dc:subject", "dc:creator", "cp:keywords",
#'   "dc:description", "cp:category"
#'
#' @param xl path to excel xlsx file
#' @param file_props document properties to set (named vector)
#' @return new filename created (this doesn't overwrite the existing since
#'         there's not enough error checking)
#' @examples
#' set_properties("path/tp/some.xlsx",
#'                c(`dc:title`="Cool Title",
#'                  `dc:subject`="Cool Subject",
#'                  `dc:creator`="Cool Creator"))
set_properties <- function(xl, file_props) {

  require(XML)

  # make a copy using .zip extension ----------------------------------------

  tmp <- tempfile(fileext=".zip")
  xl <- path.expand(xl)
  ok <- file.copy(xl, tmp)

  # unzip it and get file list ----------------------------------------------

  tmpdir <- tempfile()
  fils <- unzip(tmp, exdir=tmpdir)

  # get the doc properties file (one of them anyway) ------------------------

  props_file <- grep("docProps/core.xml", fils, value=TRUE)

  # open it -----------------------------------------------------------------

  props <- xmlTreeParse(props_file, useInternalNodes=TRUE)

  # you can do this for any of those properties
  for (tag in names(file_props)) {
    # message(sprintf("//%s", tag))
    # message(file_props[tag])
    tval <- getNodeSet(props, sprintf("//%s", tag))[[1]]
    xmlValue(tval) <- file_props[tag]
  }

  # save out the modified file ----------------------------------------------

  saveXML(props, props_file)

  # re-zip the archive ------------------------------------------------------

  unlink(tmp)
  cur <- getwd()
  setwd(tmpdir)
  zip(tmp, "./")
  setwd(cur)

  # move new xlsx to source xlsir -------------------------------------------
  new_fil <- paste0(file.path(dirname(path.expand(xl)), basename(tmpdir)), ".xlsx")
  file.copy(tmp, new_fil, overwrite=TRUE)

  new_fil
}

#' Display Excel (xlsx) document properties
#'
#' @param xl path to excel xlsx file
#' @examples
#' print_properties("path/to/some.xlsx")
print_properties <- function(xl, props) {
  require(XML)

  # make a copy using .zip extension ----------------------------------------

  tmp <- tempfile(fileext=".zip")
  xl <- path.expand(xl)
  ok <- file.copy(xl, tmp)

  # unzip it and get file list ----------------------------------------------

  tmpdir <- tempfile()
  fils <- unzip(tmp, exdir=tmpdir)

  # get the doc properties file (one of them anyway) ------------------------

  props_file <- grep("docProps/core.xml", fils, value=TRUE)

  # open it -----------------------------------------------------------------

  props <- xmlTreeParse(props_file, useInternalNodes=TRUE)
  for (tag in c("dc:title", "dc:subject", "dc:creator", "cp:keywords",
                "dc:description", "cp:category")) {
    cat(sprintf("%16s", tag), ": ", xmlValue(props[[sprintf("//%s", tag)]]), sep="", "\n")
  }

  unlink(tmp)
  unlink(tmpdir)

}
