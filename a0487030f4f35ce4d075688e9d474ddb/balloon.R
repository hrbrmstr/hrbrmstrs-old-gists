library(grImport2)
library(grConvert)
library(egg)

convertPicture("noun_3663.svg", "balloon.svg")
balloon <- readPicture("balloon.svg")


d <- data.frame(x=1:9, y=rnorm(9), 
                data = I(Map(function(c, s) list(c=c,s=s),c=blues9,s=1:9)), 
                stringsAsFactors = F)

balloonGrob <- function(data,x=0.5,y=0.5){
  grob(x=x,y=y,data=data, cl="balloon")
}

drawDetails.balloon <- function(x, recording=FALSE){
  grid.picture(x$x,x$y, picture = balloon, width = unit(x$data$s,"mm"),
               gpFUN= function(gp)modifyList(gp, list(fill=x$data$c)))
}

ggplot(d, aes(x,y))+
  geom_custom(aes(data = data), grob_fun = balloonGrob)

