shinyServer(function(input, output, session) {

  values <- reactiveValues()
  
  getMedals <- function() {
    
    # get medals from dyanmic google spreadsheet
    sochi.medals.URL = "https://docs.google.com/spreadsheets/d/1Al7I7nS0BP50IfThs55OKv5UPI9u-ctZgZRyDQma_G8/export?format=csv&gid=0"
    medals <- read.csv(textConnection(getURL(sochi.medals.URL)), stringsAsFactors = FALSE)

    # if no medals, don't show
    medals.nz <- with(medals, medals[!(Gold==0 & Silver==0 & Bronze==0),])
    
    # put rank next to Country since we're sorting by medal count
    medals.nz$Rank <- as.numeric(gsub("=", "", medals.nz$Rank))
    medals.nz$Country = sprintf("%s (%s)", medals.nz$Country, medals.nz$Rank)
    
    values$medals.nz <- medals.nz
    
  }

  getMedals()
    
  observe({
    
    # invalidate every hour
    invalidateLater(1000*60*60, session)
    
    getMedals()
    
  })
         
  output$medalsPlot <- renderPlot({ 
    
    # melt for ggplot
    medals.melted <- melt(values$medals.nz[,2:6], c("Country"))

    # gold, silver, bronze & Sochi blue
    medal.colors <- c("#ffcc33", "#999999", "#cd7f32", "#3daddf", "#3daddf")
    
    # make the pretty display
    gg <- ggplot(medals.melted, aes(x=reorder(Country, value), y=value, group=variable))
    gg <- gg + geom_segment(aes(xend=Country, yend=0, color=variable), size=0.3)
    gg <- gg + geom_point(aes(color=variable, fill=variable), shape=21, size=3)
    gg <- gg + scale_color_manual(values=medal.colors)
    gg <- gg + scale_fill_manual(values=medal.colors)
    gg <- gg + facet_wrap(~variable, ncol=4) 
    gg <- gg + scale_y_continuous(breaks=seq(0,20,4))
    gg <- gg + labs(y="Medal Count", x="", title="Sochi 2014 Live Medal Tracker")
    gg <- gg + coord_flip()
    gg <- gg + theme_bw()
    gg <- gg + theme(legend.position="none")
    gg <- gg + theme(panel.grid.major.y=element_blank())
    gg <- gg + theme(panel.grid.minor.y=element_blank())
    gg <- gg + theme(strip.background=element_blank())
    gg <- gg + theme(plot.title=element_text(face="bold", size=16, color="#3daddf"))
    gg <- gg + theme(axis.ticks=element_line(color="#7f7f7f", size=0.25))
    
    print(gg)
    
  })
  
  output$medalsTable <- renderDataTable({
    m <- values$medals.nz
    m$Country <- gsub(" \\(.*\\)", "", m$Country)
    return(m)
  }, options=list(iDisplayLength=5, aLengthMenu=c(5), bLengthChange=0, bFilter=0))
  
})