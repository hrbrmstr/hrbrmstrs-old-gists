library(ggplot2)
library(grid)

geom_point2 <- function(mapping = NULL, data = NULL,
                       stat = "identity", position = "identity",
                       ...,
                       na.rm = FALSE,
                       show.legend = NA,
                       inherit.aes = TRUE) {
  
  message("Called geom_point2()")
  
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPoint2,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

GeomPoint2 <- ggproto("GeomPoint2", Geom,
  required_aes = c("x", "y"),
  non_missing_aes = c("size", "shape", "colour"),
  default_aes = aes(
    shape = 19, colour = "black", size = 1.5, fill = NA,
    alpha = NA, stroke = 0.5
  ),

  draw_panel = function(data, panel_params, coord, na.rm = FALSE) {
    message("called draw_panel()")
    coords <- coord$transform(data, panel_params)
    ggplot2:::ggname("geom_point2",
      pointsGrob(
        coords$x, coords$y,
        pch = coords$shape,
        gp = gpar(
          col = alpha(coords$colour, coords$alpha),
          fill = alpha(coords$fill, coords$alpha),
          # Stroke is added around the outside of the point
          fontsize = coords$size * .pt + coords$stroke * .stroke / 2,
          lwd = coords$stroke * .stroke / 2
        )
      )
    )
  },

  draw_key = draw_key_point
)

ggplot(mtcars, aes(wt, mpg)) + geom_point2()

gg <- ggplot(mtcars, aes(wt, mpg)) + geom_point2()
gg