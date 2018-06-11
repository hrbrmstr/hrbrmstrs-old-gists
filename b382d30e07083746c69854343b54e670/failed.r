drill_install <- function() {

  drill_app <- app_dir("drill", "apache")

  drill_home <- drill_app$config()

  dir.create(drill_home, FALSE, TRUE)

  download.file(DRILL_TGZ_URL, sprintf("%s/%s", drill_home, DRILL_TGZ_FIL))

  gunzip(sprintf("%s/%s", drill_home, DRILL_TGZ_FIL))

  untar(sprintf("%s/%s", drill_home, DRILL_TAR_FIL), exdir=drill_home)

  file.rename(sprintf("%s/%s", drill_home, DRILL_VERSION_DIR),
              sprintf("%s/%s", drill_home, DRILL_VERSION))

}

start_drill <- function() {

  drill_app <- app_dir("drill", "apache", DRILL_VERSION)
  drill_home <- drill_app$config()

  system2()

}
