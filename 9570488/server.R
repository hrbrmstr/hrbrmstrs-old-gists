library(shiny)
library(ggplot2)
library(scales)
library(grid)
library(gridExtra)

shinyServer(function(input, output) {
   
  output$countPlot <- renderPlot({
    
    guardian <- read.csv("http://dds.ec/data/guardian.csv", stringsAsFactors=FALSE)
    
    guardian$Day <- factor(guardian$Day, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
    guardian$Date <- as.Date(guardian$Date, format="%m/%d/%Y")
    guardian$Reading.time <- as.numeric(as.difftime(guardian$Reading.time, units="secs"), units="hours")
    
    gg <- ggplot(data=guardian, group=Words)
    gg <- gg + geom_path(aes(x=Date, y=Words), size=0.5)
    gg <- gg + geom_point(aes(x=Date, y=Words, color=Day), stat="identity", size=3)
    gg <- gg + scale_y_continuous(limits=c(0, max(guardian$Words)),
                                  labels=comma)
    gg <- gg + labs(x="", y="# words", title="Word Count (per day)")
    gg <- gg + theme_bw()
    
    
    gg2 <- ggplot(data=guardian, aes(Day, Words))
    gg2 <- gg2 + geom_boxplot(aes(fill=Day))
    gg2 <- gg2 + scale_y_continuous(limits=c(0, max(guardian$Words)),
                                  labels=comma)
    gg2 <- gg2 + labs(x="", y="# words", title="Word Count Distribution by Day of Week")
    gg2 <- gg2 + theme_bw()
    gg2 <- gg2 + theme(legend.position="none")
    
    # using grid.arrange() is being lazy. will refactor once the data gets bigger
    
    print(grid.arrange(gg, gg2, ncol=1))
    
  })
  
  output$guardianTable = renderDataTable({
    
    # duplicating the read is totally lazy but the data is small enough now that it's OK.
    
    guardian <- read.csv("http://dds.ec/data/guardian.csv", stringsAsFactors=FALSE)
    
    guardian$Date <- as.Date(guardian$Date, format="%m/%d/%Y")
    guardian$Reading.time <- as.numeric(as.difftime(guardian$Reading.time, units="secs"), units="hours")
    
    # make the headers pretty
    colnames(guardian) <- c("Date", "Day", "Word Count", "Reading Time (Hours)")

    return(guardian)

  })
  
})
