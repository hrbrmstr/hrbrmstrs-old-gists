library(rgdal)
library(sp)
library(albersusa) # devtools::install_github("hrbrmstr/albersusa")
library(spdplyr) # devtools::install_github("mdsumner/spdplyr")
library(ggplot2) # devtools::install_github("hadley/ggplot2")
library(ggthemes)
library(rgeos)
library(purrr)
library(broom)
library(magick)

drought_map <- function(wk, pb=NULL) {

  if (!is.null(pb)) pb$tick()$print()

  hush_tidy <- quietly(tidy)

  old_warn <- getOption("warn")
  options(warn=-1)

  week <- format(wk, "%Y%m%d")

  tdir <- tempdir()

  URL <- sprintf("http://droughtmonitor.unl.edu/data/shapefiles_m/USDM_%s_M.zip", week)
  fil <- file.path(tdir, basename(URL))
  if (!file.exists(fil)) download.file(URL, fil, quiet=TRUE)
  unzip(fil, exdir=tdir)

  dr <- readOGR(file.path(tdir, sprintf("USDM_%s.shp", week)),
                sprintf("USDM_%s", week),
                verbose=FALSE,
                stringsAsFactors=FALSE)

  dr <- SpatialPolygonsDataFrame(gSimplify(dr, 0.01, TRUE), dr@data)

  map(dr$DM, ~filter(dr, DM==.)) %>%
    map(hush_tidy) %>%
    map_df("result", .id="DM") -> m

  usa_composite() %>%
    filter(!(iso_3166_2 %in% c("AK", "HI"))) %>%
    hush_tidy() -> usa

  usa <- usa$result

  ggplot() +
    geom_map(data=m, map=m,
             aes(long, lat, fill=DM, map_id=id),
             color="#2b2b2b", size=0.05) +
    geom_map(data=usa, map=usa, aes(long, lat, map_id=id),
             color="#2b2b2b88", fill=NA, size=0.1) +
    scale_fill_brewer("Drought Level", palette="YlOrBr") +
    coord_map("polyconic", xlim=c(-130, -65), ylim=c(25, 50)) +
    labs(x=sprintf("Week: %s", wk)) +
    theme_map() +
    theme(axis.title=element_text()) +
    theme(axis.title.x=element_text()) +
    theme(axis.title.y=element_blank()) +
    theme(legend.position="bottom") +
    theme(legend.direction="horizontal") -> gg

  options(warn=old_warn) # put things back the way they were

  outfil <- file.path(tdir, sprintf("gg-dm-%s.png", wk))
  ggsave(outfil, gg, width=8, height=5)

  outfil

}

drought_weeks <- seq(as.Date("2016-01-05"), Sys.Date(), by="1 week")

pb <- progress_estimated(length(drought_weeks))

drought_weeks %>%
  map(drought_map, pb) %>%
  map(image_read) %>%
  image_join() %>%
  image_animate(fps=2, loop=1) %>%
  image_write("drought.gif")
