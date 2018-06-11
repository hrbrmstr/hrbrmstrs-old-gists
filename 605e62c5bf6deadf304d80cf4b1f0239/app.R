#
# This Shiny web application demonstrates the use of custom image files
# in place of icons for value boxes in Shiny Dashboard by overriding two
# functions:
#
# 'icon' from the shiny package and 'valueBox' from the shinydashboard package.
#
# Each function adds minimal, specific additional handling of image files.
# Note: A custom css file must also be included so that value boxes can
# display the icons. For that reason, do not expect images in place of icons to
# work elsewhere in shiny or shinydashboard.

# Motivation: libraries like font awesome and glyphicon cannot be expected to
# provide a substantial suite of icons tailored to probability and statistics
# or many other subjects. Examples here use 13 custom icons for inspiration,
# which are simply tiny png files of native R plots. These png files must be
# placed in the app's www/ directory.
#

library(shiny)
library(shinydashboard)
library(purrr)

ui <- dashboardPage(
  dashboardHeader(title="Custom Icons"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Light icons", tabName = "light"),
      menuItem("Dark icons", tabName = "dark")
    ),
    div(a(href=post, "Related blog post"), style="width: 80%; padding: 15px"),
    div(a(href=gist, "Github gist"), style="width: 80%; padding: 15px")
  ),
  dashboardBody(
    tags$head( # must include css
      tags$style(HTML("
        .img-local {
        }
        
        .small-box .img-local {
        position: absolute;
        top: auto;
        bottom: 5px;
        right: 5px;
        z-index: 0;
        font-size: 70px;
        color: rgba(0, 0, 0, 0.15);
        }"
      ))
    ),
    tabItems(
      tabItem(tabName = "light",
              fluidRow(valueBoxOutput("distLight", width=3)),
              fluidRow(
                box(plotOutput("hist1"),
                    br(),
                    h4("Some random values for the bottom six value boxes showing delta change:"),
                    verbatimTextOutput("vals1"), status="primary", width=6),
                box(uiOutput("vBoxesLight"), status="primary", width=6)
              )
      ),
      tabItem(tabName = "dark",
              fluidRow(valueBoxOutput("distDark", width=3)),
              fluidRow(
                box(plotOutput("hist2"), 
                    br(),
                    h4("Some random values for the bottom six value boxes\nshowing delta change:"),
                    verbatimTextOutput("vals2"), status="primary", width=6),
                box(uiOutput("vBoxesDark"), status="primary", width=6)
              )
      )
    )
  ),
  title="Custom icons"
)

server <- function(input, output) {
  source("override.R", local = TRUE) # override 'icon' and 'valueBox'
  clrs <- c("yellow", "orange", "purple", "red", "blue", "navy",
            "light-blue", "teal", "olive", "green", "fuchsia", "maroon")
  
  pTextSize <- function(x, value) tags$p(x, style=paste0("font-size: ", value, "%;"))
  
  vbox <- function(vb){ # taglist around all 12 value boxes
    tagList(
      fluidRow(
        tags$head(tags$style(HTML(".small-box {height: 100px}"))),
        column(6, vb[[1]], vb[[5]], vb[[3]]),
        column(6, vb[[2]], vb[[6]], vb[[4]])
      ),
      fluidRow(
        column(6, vb[[7]], vb[[8]], vb[[9]]),
        column(6, vb[[10]], vb[[11]], vb[[12]])
      )
    )
  }
  
  # image files
  fileparts1 <- c(paste0("normal_", c("mean", "sd", "min", "max", "median"), "_"), "boxplot_iqr_")
  files_white <- paste0("stat_icon_", fileparts1, "white.png")
  files_black <- paste0("stat_icon_", fileparts1, "black.png")
  fileparts2 <- c(
    paste0("ts_", c("deltaDec_", "deltaInc_")), "bar_deltaNeg_",
    paste0("ts_", c("deltaPctDec_", "deltaPctInc_")), "bar_deltaPos_")
  files_white <- c(files_white, paste0("stat_icon_", fileparts2, "white.png"))
  files_black <- c(files_black, paste0("stat_icon_", fileparts2, "black.png"))
  
  # data
  set.seed(1)
  x <- rnorm(1000, 100, 10)
  del <- c(-154, 47, -81, "-12%", "114%", 60) # values for delta change example icons
  del.lab <- c("Total change", "Total change", "Max loss", "% change", "% change", "Max growth")
  val <- round(c(mean(x), sd(x), min(x), max(x), median(x)))
  val <- c(val, paste(round(quantile(x, probs = c(0.25, 0.75))), collapse=" - "), del)
  val <- map2(val, c(rep(100, 5), 75, rep(100, 6)), ~pTextSize(.x, .y))
  text <- map(c("Mean", "Std Dev", "Min", "Max", "Median", "IQR", del.lab), ~pTextSize(.x, 150))
  

  output$vBoxesLight <- renderUI({
    vb <- map(1:12, ~valueBox(
      val[[.x]], text[[.x]],
      icon=icon(list(src=files_white[.x], width="80px"), lib="local"),
      color=clrs[.x], width=NULL)
    )
    vbox(vb)
  })
  
  output$vBoxesDark <- renderUI({
    vb <- map(1:12, ~valueBox(
      val[[.x]], text[[.x]],
      icon=icon(list(src=files_black[.x], width="80px"), lib="local"),
      color=clrs[.x], width=NULL)
    )
    vbox(vb)
  })
  
  output$distLight <- renderValueBox({
    x <- "stat_icon_normal_dist_white.png"
    valueBox("Data", "light image icon color",
             icon=icon(list(src=x, width="80px"), lib="local"),
             color="black", width=NULL)
  })
  
  output$distDark <- renderValueBox({
    x <- "stat_icon_normal_dist_black.png"
    valueBox("Data", "dark image icon color",
             icon=icon(list(src=x, width="80px"), lib="local"),
             color="aqua", width=NULL)
  })
  
  output$hist1 <- renderPlot({ hist(x) })
  output$hist2 <- renderPlot({ hist(x) })
  output$vals1 <- renderText({ del })
  output$vals2 <- renderText({ del })
}

# Run the application 
shinyApp(ui = ui, server = server)
