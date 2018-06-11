library(pack)

cmyk <- function(C, M, Y, K) {

  C <- C / 100.0
  M <- M / 100.0
  Y <- Y / 100.0
  K <- K / 100.0

  n.c <- (C * (1-K) + K)
  n.m <- (M * (1-K) + K)
  n.y <- (Y * (1-K) + K)

  r.col <- ceiling(255 * (1-n.c))
  g.col <- ceiling(255 * (1-n.m))
  b.col <- ceiling(255 * (1-n.y))

  return(sprintf("#%02s%02s%02s", as.hexmode(r.col), as.hexmode(g.col), as.hexmode(b.col)))

}

read_aco <- function(path) {

  aco <- readBin(path.expand(path), "raw",
                 file.info(path.expand(path))$size, endian="big")

  version <- unpack("v", aco[2:1])[[1]]
  n_colors <- unpack("v", aco[4:3])[[1]]

  message("Version: ", version)
  message("# Colors: " , n_colors)

  if (version == 1) {

    palette <- sapply(1:n_colors, function(i) {

      start <- 6 + (10*(i-1))

      colorspace <- as.numeric(unpack("v", aco[start:start-1]))

      start <- start + 2
      w <- as.numeric(unpack("v", aco[start:(start-1)]))

      start <- start + 2
      x <- as.numeric(unpack("v", aco[start:(start-1)]))

      start <- start + 2
      y <- as.numeric(unpack("v", aco[start:(start-1)]))

      start <- start + 2
      z <- as.numeric(unpack("v", aco[start:(start-1)]))

      color <- ""

      if (colorspace == 0) { # RGB
        color <- rgb(w, x, y, maxColorValue=65535)
      } else if (colorspace == 1) { # HSB
        color <- hsv((w/182.04)/360, ((x/655.35)/360), ((y/655.35)/360))
      } else if (colorspace == 2) { # CMYK
#         message("CMYK ", (100-w/655.35))
        color <- cmyk((100-w/655.35), (100-x/655.35), (100-y/655.35), (100-z/655.35))
#         message(color)
      } else if (colorspace == 7) { # Lab
        message("Lab")
        color <- NA
      } else if (colorspace == 8) { # Grayscale
        message("Grayscale")
        color <- NA
      } else if (colorspace == 9) { # Wide CMYK
        message("Wide CMYK")
        color <- NA
      } else {
        color <- NA
      }

      return(color)


    })

  } else {

    start <- 5

    palette <- sapply(1:n_colors, function(i) {

      colorspace <- as.numeric(unpack("v", aco[(start+1):start]))
#       message("colorspace: ", colorspace)

      start <<- start + 2
      w <- as.numeric(unpack("v", aco[(start+1):start]))

      start <<- start + 2
      x <- as.numeric(unpack("v", aco[(start+1):start]))

      start <<- start + 2
      y <- as.numeric(unpack("v", aco[(start+1):start]))

      start <<- start + 2
      z <- as.numeric(unpack("v", aco[(start+1):start]))

      start <<- start + 2 # zero
      start <<- start + 2

      len <<- as.numeric(unpack("v", aco[(start+1):start]))

      start <<- start + 2

      c_name <- unpack(sprintf("v%d", (len+1)), aco[start:(start+len)])
#       message("color name: ", c_name)

      start <<- start + len + 1 + 2
      start <<- start + 2

      color <- ""

      if (colorspace == 0) { # RGB
        color <- rgb(w, x, y, maxColorValue=65535)
      } else if (colorspace == 1) { # HSB
        color <- hsv((w/182.04)/360, ((x/655.35)/360), ((y/655.35)/360))
      } else if (colorspace == 2) { # CMYKq
#         message("CMYK ", (100-w/655.35))
        color <- cmyk((100-w/655.35), (100-x/655.35), (100-y/655.35), (100-z/655.35))
#         message(color)
      } else if (colorspace == 7) { # Lab
        message("Lab")
        color <- NA
      } else if (colorspace == 8) { # Grayscale
        message("Grayscale")
        color <- NA
      } else if (colorspace == 9) { # Wide CMYK
        message("Wide CMYK")
        color <- NA
      } else {
        color <- NA
      }

      return(color)

    })

  }

}

palette <- read_aco("~/Desktop/Swatches.aco")
