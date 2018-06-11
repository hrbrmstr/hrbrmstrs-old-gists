#' @export
coord_proj <- function(proj="+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs",
                       inverse = FALSE, degrees = TRUE,
                       ellps.default="sphere", xlim = NULL, ylim = NULL) {
  try_require("proj4")
  coord(
    proj = proj,
    inverse = inverse,
    ellps.default = ellps.default,
    degrees = degrees,
    limits = list(x = xlim, y = ylim),
    subclass = "proj"
  )
}

#' @export
is.linear.proj <- function(coord) TRUE

coord_expand_defaults.proj <- function(coord, scale, n) {
  discrete <- c(0, 0)
  continuous <- c(0, 0)
  expand_default(scale, discrete, continuous)
}

#' @export
coord_transform.proj <- function(coord, data, details) {
  trans <- project4(coord, data$x, data$y)
  out <- cunion(trans[c("x", "y")], data)

  out$x <- rescale(out$x, 0:1, details$x.proj)
  out$y <- rescale(out$y, 0:1, details$y.proj)
  out
}

project4 <- function(coord, x, y) {

  df <- data.frame(x=x, y=y)

  # map extremes cause issues with projections both with proj4 &
  # spTransform. this compensates for them.

  df$x <- ifelse(df$x <= -180, -179.999999999, df$x)
  df$x <- ifelse(df$x >= 180, 179.999999999, df$x)
  df$y <- ifelse(df$y <= -90, -89.999999999, df$y)
  df$y <- ifelse(df$y >= 90, 89.999999999, df$y)

  suppressWarnings({
    res <- proj4::project(list(x=df$x, y=df$y),
                          proj = coord$proj,
                          inverse = coord$inverse,
                          degrees  = coord$degrees,
                          ellps.default = coord$ellps.default)
    res$range <- c(range(res$x, na.rm=TRUE), range(res$y, na.rm=TRUE))
    res$error <- 0
    res
  })
}

#' @export
coord_distance.proj <- function(coord, x, y, details) {
  max_dist <- dist_central_angle(details$x.range, details$y.range)
  dist_central_angle(x, y) / max_dist
}

#' @export
coord_aspect.proj <- function(coord, ranges) {
  diff(ranges$y.proj) / diff(ranges$x.proj)
}

#' @export
coord_train.proj <- function(coord, scales) {

  # range in scale
  ranges <- list()
  for (n in c("x", "y")) {

    scale <- scales[[n]]
    limits <- coord$limits[[n]]

    if (is.null(limits)) {
      expand <- coord_expand_defaults(coord, scale, n)
      range <- scale_dimension(scale, expand)
    } else {
      range <- range(scale_transform(scale, limits))
    }
    ranges[[n]] <- range
  }

  orientation <- coord$orientation %||% c(90, 0, mean(ranges$x))

  # Increase chances of creating valid boundary region
  grid <- expand.grid(
    x = seq(ranges$x[1], ranges$x[2], length = 50),
    y = seq(ranges$y[1], ranges$y[2], length = 50)
  )

  ret <- list(x = list(), y = list())

  # range in map

  proj <- project4(coord, grid$x, grid$y)$range
  ret$x$proj <- proj[1:2]
  ret$y$proj <- proj[3:4]

  for (n in c("x", "y")) {
    out <- scale_break_info(scales[[n]], ranges[[n]])
    ret[[n]]$range <- out$range
    ret[[n]]$major <- out$major_source
    ret[[n]]$minor <- out$minor_source
    ret[[n]]$labels <- out$labels
  }

  details <- list(
    orientation = orientation,
    x.range = ret$x$range, y.range = ret$y$range,
    x.proj = ret$x$proj, y.proj = ret$y$proj,
    x.major = ret$x$major, x.minor = ret$x$minor, x.labels = ret$x$labels,
    y.major = ret$y$major, y.minor = ret$y$minor, y.labels = ret$y$labels
  )
  details
}

#' @export
coord_render_bg.proj <- function(coord, details, theme) {
  xrange <- expand_range(details$x.range, 0.2)
  yrange <- expand_range(details$y.range, 0.2)

  # Limit ranges so that lines don't wrap around globe
  xmid <- mean(xrange)
  ymid <- mean(yrange)
  xrange[xrange < xmid - 180] <- xmid - 180
  xrange[xrange > xmid + 180] <- xmid + 180
  yrange[yrange < ymid - 90] <- ymid - 90
  yrange[yrange > ymid + 90] <- ymid + 90

  xgrid <- with(details, expand.grid(
    y = c(seq(yrange[1], yrange[2], len = 50), NA),
    x = x.major
  ))
  ygrid <- with(details, expand.grid(
    x = c(seq(xrange[1], xrange[2], len = 50), NA),
    y = y.major
  ))

  xlines <- coord_transform(coord, xgrid, details)
  ylines <- coord_transform(coord, ygrid, details)

  if (nrow(xlines) > 0) {
    grob.xlines <- element_render(
      theme, "panel.grid.major.x",
      xlines$x, xlines$y, default.units = "native"
    )
  } else {
    grob.xlines <- zeroGrob()
  }

  if (nrow(ylines) > 0) {
    grob.ylines <- element_render(
      theme, "panel.grid.major.y",
      ylines$x, ylines$y, default.units = "native"
    )
  } else {
    grob.ylines <- zeroGrob()
  }

  ggname("grill", grobTree(
    element_render(theme, "panel.background"),
    grob.xlines, grob.ylines
  ))
}

#' @export
coord_render_axis_h.proj <- function(coord, details, theme) {
  if (is.null(details$x.major)) return(zeroGrob())

  x_intercept <- with(details, data.frame(
    x = x.major,
    y = y.range[1]
  ))
  pos <- coord_transform(coord, x_intercept, details)

  guide_axis(pos$x, details$x.labels, "bottom", theme)
}
#' @export
coord_render_axis_v.proj <- function(coord, details, theme) {
  if (is.null(details$y.major)) return(zeroGrob())

  x_intercept <- with(details, data.frame(
    x = x.range[1],
    y = y.major
  ))
  pos <- coord_transform(coord, x_intercept, details)

  guide_axis(pos$y, details$y.labels, "left", theme)
}
