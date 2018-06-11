notify <- function(msg="Operation complete") {

  in.osx <- (Sys.info()['sysname'] == "Darwin")
  in.rstudio <- (Sys.getenv("RSTUDIO") == "1")
  in.rgui <- (Sys.getenv("R_GUI_APP_REVISION") != "")
  
  if (in.rstudio) { # hack to see if running in RStudio
    title <- "RStudio"
    sender <- activate <- "org.rstudio.RStudio"
  }
  
  if (in.rgui) { # running in R GUI app?
    title <- "R GUI"
    sender <- activate <- "org.R-project.R"
  }
  
  # if running in RStudio or R GUI app use NotificationCenter otherwise use message()
  if ((in.rstudio | in.rgui) & in.osx) {
    system(sprintf("/usr/bin/terminal-notifier -title '%s' -message '%s' -sender %s -activate %s",
                   title, msg, sender, activate ),
           ignore.stdout=TRUE, ignore.stderr=TRUE, wait=FALSE)
  } else {
    message(msg)      
  }
  
}

# try it!
# library(source.gist) # install.packages("source.gist")
# source.gist(6545433)
# system("sleep 10")
# notify("Long op complete")