library(ggplot2)
library(purrr)

# rig up some added dfs

mtcars2 <- mtcars
mtcars2$wt2 <- mtcars2$wt + 1
mtcars2$mpg2 <- mtcars2$mpg + 1

mtcars3 <- mtcars
mtcars3$wt3 <- mtcars3$wt + 2
mtcars3$mpg3 <- mtcars3$mpg + 2

gg <- ggplot(mtcars, aes(wt, mpg))
gg <- gg + geom_line()
gg <- gg + geom_point(data=mtcars2, aes(wt2+1, mpg2), size=4, color="white")
gg <- gg + geom_bar(data=mtcars3, aes(wt3, mpg3), stat="identity")
gg


# need to either make a dict for all the geoms or do an inverse trans from CamelCase
# to snake_case like the print for ggplot2 objects does.
geoms <- c(`GeomPoint`="geom_point", `GeomLine`="geom_line", `GeomBar`="geom_bar")

# have to do this for the geoms, scales, etc but this is the general idea
# the case where there's data and aes in the main ggplot() call also has to be
# dealt with 

walk(gg$layers, function(x) {
  geom <- geoms[class(x$geom)[1]]
  gdata <- ""
  if (length(x$data) != 0) gdata <- "data=df, " # need to make these unique and make a list of df's eventually
  gmap <- ""
  if (length(x$mapping) != 0) {
    gmap <- map_chr(names(x$mapping), function(y) {
      sprintf("`%s`=%s", y, deparse(x$mapping[[y]])) 
    }) %>% paste0(collapse=", ")
    gmap <- sprintf("aes(%s), ", gmap)
  }
  amap <- ""
  if (length(x$aes_params) != 0) {
    amap <- map_chr(names(x$aes_params), function(y) {
      sprintf("%s=%s", y, deparse(x$aes_params[[y]])) 
    }) %>% paste0(collapse=", ")
  }
  narm <- sprintf("na.rm=%s, ", x$geom_params$na.rm)
  cat(sub(", \\)$", ")", sprintf("%s(%s%s%s%s)", geom, gdata, gmap, narm, amap)), "\n")
})

gg$layers[[2]]$aes_params
