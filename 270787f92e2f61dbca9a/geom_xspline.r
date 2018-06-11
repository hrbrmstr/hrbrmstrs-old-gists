library(dplyr)
library(ggplot2)

xspline_int <- function(dat, shape, open, rep_ends) {

  # despite the "draw=FALSE" parameter, xspline still
  # tries to use the graphics device so we have to
  # do this to work around it
  tf <- tempfile(fileext=".png")
  png(tf)
  plot.new()
  tmp <- xspline(dat$x, dat$y, shape, open, rep_ends, draw=FALSE, NA, NA)
  invisible(dev.off())
  unlink(tf)

  data.frame(x=tmp$x, y=tmp$y)

}

GeomXspline <- ggproto("GeomXspline", GeomLine,

  required_aes = c("x", "y", "spline_shape", "open", "rep_ends"),

  default_aes = aes(colour = "black", size = 0.5, linetype = 1, alpha = NA),

  setup_data = function(data, params) {
    cols <- setdiff(colnames(data), c("x", "y"))
    sdat <- group_by_(data, .dots=cols)
    sdat <- ungroup(do(sdat,
                       xspline_int(., params$spline_shape, params$open, params$rep_ends)))
    data.frame(sdat)
  }
)

geom_xspline <- function(mapping = NULL, data = NULL, stat = "identity",
                      position = "identity", show.legend = NA,
                      inherit.aes = TRUE, na.rm = TRUE,
                      spline_shape=-0.25, open=TRUE, rep_ends=TRUE, ...) {
  layer(
    geom = GeomSpline, mapping = mapping,  data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(spline_shape=spline_shape, open=open, rep_ends=rep_ends, ...)
  )
}

dat <- data.frame(x=c(1:10, 1:10),
                  y=c( c(22,23,21,25,23,24,20,27,22,24),
                       2*c(22,23,21,25,23,24,20,27,22,24)),
                  group=c(rep(1, 10), rep(2, 10))
)

ggplot(dat, aes(x, y, group=group)) +
  geom_xspline(aes(colour=factor(group)), spline_shape=-0.25) +
  geom_xspline(spline_shape=1, open=FALSE) +
  geom_smooth(method="loess", se=FALSE)

