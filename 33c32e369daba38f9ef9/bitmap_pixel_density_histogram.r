#' Make a "row color density" histogram for an image file
#' 
#' Takes a file path to a png and returns displays it with a histogram of 
#' pixel density
#' 
#' @param img_file path to png file
#' @param ignore_colors colors to ignore (can be huge vector of hex strings). 
#'        the alpha channel is thrown away if any, so you only need to specify
#'        #rrggbb hex strings
#' @param color to use for the density histogram line
make_img_row_hist <- function(img_file, 
                          ignore_colors=c("#ffffff", "#000000"),
                          hist_col="steelblue") {
  
  require(png)
  require(grid)
  require(raster)
  require(gridExtra)

  ignore_colors <- tolower(ignore_colors)  

  png_file <- readPNG(img_file)
  
  img <- substr(tolower(as.matrix(as.raster(png_file))), 1, 7)
  
  rowSums(apply(img, 1, function(x) {
    !(x %in% ignore_colors)
  })) -> wvals

  wdth <- max(wvals) + round(0.1*max(wvals))

  hmat <- matrix(rep("#ffffff", wdth*nrow(img)), nrow=nrow(img), ncol=wdth)
  for (i in 1:nrow(img)) { hmat[i, 1:wvals[i]] <- hist_col }

  new_img <- cbind(img, hmat)
    
  colSums(apply(img, 2, function(x) {
    !(x %in% ignore_colors)
  })) -> hvals

  hght <- max(hvals) + round(0.1*max(hvals))
  
  vmat <- matrix(rep("#ffffff", hght*ncol(new_img)), ncol=ncol(new_img), nrow=hght)
  for (i in 1:ncol(img)) { vmat[1:hvals[i], i] <- hist_col }
  
  rg1 <- rasterGrob(rbind(new_img, vmat))
  
  grid.arrange(rg1)
  
}

make_img_row_hist("conditionA.png", hist_col="#f6743d")

make_img_row_hist("conditionB.png", hist_col="#80b1d4")
