library(ggplot2)
library(ggmap)

vectorDestination <- function(lonlatpoint, travelvector) { 
  
  Rearth <- 6372795 
  
  Dd <- travelvector$magnitude / Rearth 
  Cc <- travelvector$direction 
  
  if (class(lonlatpoint) == "SpatialPoints") { 
    lata <- coordinates(lonlatpoint)[1,2] * (pi/180) 
    lona <- coordinates(lonlatpoint)[1,1] * (pi/180) 
  } else { 
    lata <- lonlatpoint[2] * (pi/180) 
    lona <- lonlatpoint[1] * (pi/180) 
  } 
  
  latb <- asin(cos(Cc) * cos(lata) * sin(Dd) + sin(lata) * cos(Dd)) 
  dlon <- atan2(cos(Dd) - sin(lata) * sin(latb), sin(Cc) * sin(Dd) * cos(lata)) 
  lonb <- lona - dlon + pi/2 
  
  lonb[lonb >  pi] <- lonb[lonb >  pi] - 2 * pi 
  lonb[lonb < -pi] <- lonb[lonb < -pi] + 2 * pi 
  
  latb <- latb * (180 / pi) 
  lonb <- lonb * (180 / pi) 
  
  cbind(longitude = lonb, latitude = latb) 
  
} 

Leith <- c(lon=-3.1700, lat=55.9801) #c(lon,lat) 

leith_map <- get_map(Leith, zoom=3)

radius_500 <- 804672 # in meter 

circlevector_500 <- as.data.frame(cbind(direction = seq(0, 2*pi, by=2*pi/100), 
                                         magnitude = radius)) 
circlevector_1000 <- as.data.frame(cbind(direction = seq(0, 2*pi, by=2*pi/100), 
                                          magnitude = 2*radius)) 

circle_500 <- data.frame(vectorDestination(Leith, circlevector_500))
circle_1000 <- data.frame(vectorDestination(Leith, circlevector_1000))

txt <- data.frame(longitude <- c(-10, -38),
                  latitude <- c(56, 23),
                  color <- c("red", "black"),
                  label <- c("500 Miles", 
                             "Assuming they started in Leith, where\nwere The Proclaimers actually walking to?"))


gg <- ggmap(leith_map)
gg <- gg + geom_polygon(data=circle_1000, aes(x=longitude, y=latitude), alpha=0.25, fill="#3288bd", color="#3288bd")
gg <- gg + geom_polygon(data=circle_500, aes(x=longitude, y=latitude), alpha=0.25, fill="#d53e4f", color="#d53e4f")
gg <- gg + geom_text(data=txt, aes(x=longitude, y=latitude, label=label, color=color), size=4)
gg <- gg + scale_color_manual(values=c("black", "red"))
gg <- gg + coord_map()
gg <- gg + theme(legend.position="none")
gg






