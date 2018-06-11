library(purrr)
library(dplyr)
library(XML)

read_plist <- safely(readKeyValueDB)
safe_compare <- safely(compareVersion)

apps <- list.dirs(c("/Applications", "/Applications/Utilities"), recursive=FALSE)

# if you have something further than this far down that's bad you're on your own

for (i in 1:4) {
  moar_dirs <- grep("app$", apps, value=TRUE, invert=TRUE)
  if (length(moar_dirs) > 0) { apps <- c(apps, list.dirs(moar_dirs, recursive=FALSE)) }
}
apps <- unique(grep("app$", apps, value=TRUE))

pb <- txtProgressBar(0, length(apps), style=3)

suppressWarnings(map_df(1:length(apps), function(i) {
  
  x <- apps[i]
  
  setTxtProgressBar(pb, i)
  
  is_vuln <- FALSE
  version <- ""
  
  app_name <- sub("\\.app$", "", basename(x))
  app_loc <- sub("^/", "", dirname(x))
  
  to_look <- c(sprintf("%s/Contents/Frameworks/Autoupdate.app/Contents/Info.plist", x),
               sprintf("%s/Contents/Frameworks/Sparkle.framework/Versions/A/Resources/Info.plist", x),
               sprintf("%s/Contents/Frameworks/Sparkle.framework/Versions/A/Resources/Autoupdate.app/Contents/Info.plist", x))
  
  is_there <- map_lgl(c(sprintf("%s/Contents/Frameworks/Sparkle.framework/", x), to_look), file.exists)
  
  has_sparkle <- any(is_there)
  
  to_look <- to_look[which(is_there[-1])]
  
  discard(map_chr(to_look, function(x) {
    read_plist(x)$result$CFBundleShortVersionString %||% NA
  }), is.na) -> vs
  
  if (any(map_dbl(vs, function(v) { safe_compare(v, "1.16.1")$result %||% -1 }) < 0)) {
    is_vuln <- TRUE
    version <- vs[1]
  }
  
  data_frame(app_loc, app_name, has_sparkle, is_vuln, version)
  
})) -> app_scan_results

close(pb)

select(arrange(filter(app_scan_results, has_sparkle), app_loc, app_name), -has_sparkle)
