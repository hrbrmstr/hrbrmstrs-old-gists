library(shiny)

# Define UI for miles per gallon application
shinyUI(bootstrapPage(

  tags$head(
    tags$title('Central Maine Power Live Outage Map')
  ),
  
  tags$head(
	  tags$link(href='http://fonts.googleapis.com/css?family=Lato:300,400', rel = 'stylesheet', type = 'text/css')
  ),

  tags$head(tags$style(type="text/css",
                         "html, body, div, p { font-family: 'Lato', Helvetica, sans-serif; font-weight: 300; }",
                         "h2, h2 { font-family: 'Lato', Helvetica, sans-serif; font-weight: 400; }",
						 "body { margin:20px; }",
						 "h2 { text-align:center; }",
						 "h3 { text-align:center; }",
						 "div { text-align:center; }"
						 )),

  h2("Central Maine Power Live Outage Map"),
  htmlOutput('ts'),
  plotOutput(outputId = "cmpPlot", height="650px"),
  dataTableOutput('details'),
  HTML("<hr noshade size=1><center>Made by <a href='http://twitter.com/hrbrmstr'>@hrbrmstr</a>; Source at: <a href='https://gist.github.com/hrbrmstr/7681842'>github</a></center>")

))
