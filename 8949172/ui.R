shinyUI(bootstrapPage(
  
  mainPanel(
    tabsetPanel(
      tabPanel("Chart", plotOutput("medalsPlot", width="100%")),
      tabPanel("Table", dataTableOutput("medalsTable"))
    ),
    HTML("<hr noshade size='1'/>"),
    HTML("<div style='font-size:8pt; text-align:right; width:100%'>Updates hourly. See <a href='https://gist.github.com/hrbrmstr/8949172'>this gist</a> and <a href='http://rud.is/b/2014/02/11/live-google-spreadsheet-for-keeping-track-of-sochi-medals/'>this blog post</a> for more info.<br/>Shiny hosting provided by <a href='http://dds.ec/'>Data Driven Security</a></div>")
  )

))
