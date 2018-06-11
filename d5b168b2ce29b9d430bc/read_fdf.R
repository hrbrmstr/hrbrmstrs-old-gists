library(stringr)

# read in fdf file
l <- readLines("/Users/hrbrmstr/Desktop/siesta-3.2/Examples/Fe/Fe.fdf")

# some basic cleanup
l <- sub("#.*$", "", l)
l <- sub("^=.*$", "", l)
l <- gsub("\ +", " ", l)
l <- str_trim(l)
l <- grep("^$", l, value=TRUE, invert=TRUE)

# start of data blocks
blocks <- which(grepl("^%block", l))

# all "easy"/simple conversions
simple <- str_split_fixed(grep("^[[:digit:]%]", l, value=TRUE, invert=TRUE),
                          "[[:space:]]+", 2)

convert_vals <- function(simple) {

  vals <- simple[,2]
  names(vals) <- simple[,1]

  lapply(vals, function(v) {

    # if logical
    if (tolower(v) %in% c("t", "true", ".true.", "f", "false", ".false.")) {
      return(as.logical(gsub("\\.", "", v)))
    }

    # if it's just a number
    # i may be missing a numeric fmt char in this horrible format
    if (grepl("^[[:digit:]\\.\\+\\-]+$", v)) {
      return(as.numeric(v))
    }

    # if value and unit convert to an actual number with a unit attribute
    # or convert it here from the table starting on line 927 of fdf.f
    if (grepl("^[[:digit:]]", v) & (!any(is.na(str_locate(v, " "))))) {
      vu <- str_split_fixed(v, " ", 2)
      x <- as.numeric(vu[,1])
      attr(x, "unit") <- vu[,2]
      return(x)
    }

    # handle "1.d-3" and other vals with other if's

    # anything not handled is returned
    return(v)

  })

}


convert_blocks <- function(lines) {

  block_names <- sub("^%block ", "", grep("^%block", lines, value=TRUE))
  lapply(blocks, function(blk_start) {
    blk <- lines[blk_start]
    blk_info <- str_split_fixed(blk, " ", 2)
    blk_end <- which(grepl(sprintf("^%%endblock %s", blk_info[,2]), lines))
    
    # this is overly simplistic since you have to do some conversions, but you know the line
    # range of the data values now so you can process them however you need to
    read.table(text=lines[(blk_start+1):(blk_end-1)], 
               header=FALSE, stringsAsFactors=FALSE, fill=TRUE)
    
  }) -> blks

  names(blks) <- block_names
  
  return(blks)

}

fdf <- c(convert_vals(simple),
         convert_blocks(l))
