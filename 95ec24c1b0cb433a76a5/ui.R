
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Shiny Snowfall"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      textInput("zip", "Enter a 5-digit U.S. ZIP (postal) code to see the associated region's first snowfall data:", value="03901"),
      actionButton("lookup", "Lookup Snowfall Records"), 
      actionButton("bye", "Quit Shiny App"),
      p(HTML("<br/><br/>Built by <a href='http://twitter.com/hrbrmstr'>@hrbrmstr</a><br/><br/>See the <a href='http://rud.is/b/2014/11/26/visualizing-historical-most-likely-first-snowfall-dates-for-u-s-regions/'>blog post</a> for more info"))
    ),


    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("snowPlot")
    )
  )
))
