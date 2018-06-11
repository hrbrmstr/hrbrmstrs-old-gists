viridis_pal <- function(alpha=1) {
  function(n) {
    viridis(n, alpha)
  }
}


scale_color_viridis <- function(..., alpha=1, discrete=TRUE) {
  if (discrete) {
    discrete_scale("colour", "viridis", viridis_pal(alpha), ...)
  } else {
    scale_color_gradientn(colours = viridis(256, alpha), ...)
  }
}

scale_fill_viridis <- function (..., alpha=1, discrete=TRUE) {
  if (discrete) {
    discrete_scale("fill", "viridis", viridis_pal(alpha), ...)
  } else {
    scale_fill_gradientn(colours = viridis(256, alpha), ...)
  }
}
