library(shiny)

shinyUI(fluidPage(

  titlePanel("SweetheaRstats"),

  verticalLayout(plotOutput("hearts"),
                 p(a(href="https://gist.github.com/hrbrmstr/cf34f7230c88bd99b153", "gist with code"),
                 span(" • "),
                 a(href="http://twitter.com/hrbrmstr", "Made by @hrbrmstr")))

))