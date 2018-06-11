library(ggplot2)
library(ggthemes)
library(sp)

#' Make smooth polys from points
#'
#' From: http://gis.stackexchange.com/a/24929/29544
#'
#' @param xy n x 2 matrix with n >= k
#' @param k # of vertices to expand points to
#' @param ... other args passed to \code{spline()}
spline.poly <- function(xy, vertices, k=3, ...) {

  # Wrap k vertices around each end.
  n <- dim(xy)[1]
  if (k >= 1) {
    data <- rbind(xy[(n-k+1):n,], xy, xy[1:k, ])
  } else {
    data <- xy
  }

  # Spline the x and y coordinates.
  data.spline <- spline(1:(n+2*k), data[,1], n=vertices, ...)
  x <- data.spline$x
  x1 <- data.spline$y
  x2 <- spline(1:(n+2*k), data[,2], n=vertices, ...)$y

  # Retain only the middle part.
  cbind(x1, x2)[k < x & x <= n+k, ]
}


trees <- read.csv("CrownsExample.csv")
trees <- trees[with(trees, order(TREE, POINT)),]

# plot just points colored by tree to make sure points look ok
ggplot(trees, aes(x=X, y=Y, color=factor(TREE))) + coord_equal() + geom_point()

# small function to avoid anonymous fnction in `by` make a polygon from our points
make_tree_poly <- function(tree) {
  tree_pts <- spline.poly(as.matrix(tree[, c("X", "Y")]), 100)
  Polygons(list(Polygon(tree_pts)), ID=unique(tree$TREE))
}

# for each tree, make a set of smoothed polygons then make the whole thing
# a SpatialPolygonsDataFrame so more spatial ops can be done on it (or more
# data stored with it)
tree_polys <- SpatialPolygonsDataFrame(
  SpatialPolygons(unclass(by(trees, trees$TREE, make_tree_poly)),
                  proj4string=CRS("+proj=utm +zone=32 +ellps=GRS80 +units=m +no_defs ")),
  data.frame(id=unique(trees$TREE), row.names=unique(trees$TREE)))

# plot the new polygon tree crowns colored by tree
tree_map <- fortify(tree_polys)
ggplot() +
  geom_map(data=tree_map, map=tree_map,
           aes(x=long, y=lat, fill=id, map_id=id, color=id)) +
  geom_point(data=trees, aes(x=X, y=Y)) +
  coord_equal() +
  theme_map()

