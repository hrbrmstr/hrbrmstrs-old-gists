library(shiny)

shinyUI(basicPage(
  
  headerPanel("Guardian Words"),
  
  mainPanel(
    HTML("Data from <a href='http://gu-word-count.appspot.com/archive'>http://gu-word-count.appspot.com/archive</a>. Charts/data update daily.<br/><br/>"),
    tabsetPanel(
      tabPanel("Vis",plotOutput("countPlot")),
      tabPanel("Data",dataTableOutput("guardianTable")),
      tabPanel("Inspired by", HTML('<blockquote class="twitter-tweet" lang="en"><p>Want to know num of words written in each day&#39;s Guardian paper by section + approx reading time? <a href="http://t.co/wP4W1EzUsx">http://t.co/wP4W1EzUsx</a> via <a href="https://twitter.com/bengoldacre">@bengoldacre</a></p>&mdash; Andy Kirk (@visualisingdata) <a href="https://twitter.com/visualisingdata/statuses/444772698053693440">March 15, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>'))
    ),
    HTML('<hr noshade size="1"/>By <a href="http://twitter.com/hrbrmstr">@hrbrmstr</a>')
  )

))
