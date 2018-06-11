library(shiny)

ui <- fluidPage(
  
  verbatimTextOutput("results"),
  
  uiOutput("vid"),

  tags$script('
    var id = setInterval(vid_pos, 100);
    function vid_pos() {
      var video = document.getElementById("vidid");
      var curtime = video.currentTime;
      console.log(video);
      Shiny.onInputChange("posdata", curtime);
    };
  ')
)

server <- function(input, output) {

  output$vid <- renderUI({
    tags$video(id="vidid", src="small.mp4", type="video/mp4", width="480px", height="360px", controls="controls")
  })
  
  output$results = renderPrint({
    input$posdata
  })

}

shinyApp(ui, server)
