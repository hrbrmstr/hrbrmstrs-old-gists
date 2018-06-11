library(sp)
library(stringr)

dat <- readLines("subregions.csv")

SpatialPolygons(lapply(dat, function(x) {

  region <- str_split_fixed(x, ",", 2)[,1]
  poly_pts <- as.numeric(str_split(str_split_fixed(x, ",", 2)[,2], ",")[[1]])
  poly_mat <- matrix(c(poly_pts, poly_pts[1], poly_pts[2]), ncol=2, byrow=TRUE)
  tmp <- poly_mat[,2]
  poly_mat[,2] <- poly_mat[,1]
  poly_mat[,1] <- tmp
  Polygons(list(Polygon(poly_mat)), ID=region)
  
}), proj4string=CRS("+proj=longlat")) -> subr

subr_dat <- data.frame(id=sapply(subr@polygons, function(x) { slot(x, "ID") }),
             stringsAsFactors=FALSE)
rownames(subr_dat) <- subr_dat$id

subr <- SpatialPolygonsDataFrame(subr, subr_dat)

plot(subr)

library(geojsonio)
geojson_write(subr, geometry="polygon", file="subregions.geojson")
