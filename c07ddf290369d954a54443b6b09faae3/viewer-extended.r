options(viewer = function (url, height = NULL, append=FALSE)  {
  
  # USE AN ENVIRONMENT SEPARATE FROM GLOBAL BUT ACCESSIBLE
  # THIS WILL MAINTAIN CURRENT OUTPUT FILE LOCATION
  
  # IF append IS TRUE THEN INSERT THE NEW HTML AT THE END OF THE FILE
  # THERE ARE LOTS OF WAYS TO DO THIS. ONE IS IFRAME-ing EACH AS THEY
  # ARE APPENDED. ANOTHER IS TO JUST SMUSH THEM ALL TOGETHER
  
  # MAKE url THE FILE WE JUST MODIFIED
  
  # IF append=FALSE DON'T WORRY ABOUT ANYTHING AND JUST USE url

  # THE REST OF THE CODE STAYS PRETTY MUCH THE SAME
  
  if (!is.character(url) || (length(url) != 1)) 
    stop("url must be a single element character vector.", 
         call. = FALSE)
  if (identical(height, "maximize")) 
    height <- -1
  if (!is.null(height) && (!is.numeric(height) || (length(height) != 
                                                   1))) 
    stop("height must be a single element numeric vector or 'maximize'.", 
         call. = FALSE)
  invisible(.Call("rs_viewer", url, height))
  
})
