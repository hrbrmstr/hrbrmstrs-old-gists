doInstall <- TRUE
toInstall <- c("XML", "maps", "ggplot2", "sp")
if(doInstall){install.packages(toInstall, repos = "http://cran.us.r-project.org")}
lapply(toInstall, library, character.only = TRUE)

myURL <- "http://en.wikipedia.org/wiki/United_States_presidential_election,_2012"

allTables <- readHTMLTable(myURL)
str(allTables)  # Look at the allTables object to find the specific table we want
stateTable <- allTables[[14]]  # We want the 14th table in the list (maybe 13th?)
head(stateTable)

# Clean up:
stateTable <- stateTable[1:(nrow(stateTable)-1), ]  # Drop summary lines
stateTable$State <- do.call(rbind, strsplit(as.character(stateTable$State), "\\["))[, 1]
stateTable$State[stateTable$State == "District of ColumbiaDistrict of Columbia"] <- "District of Columbia"
whichAreNumeric <- colMeans(apply(stateTable, 2, function(cc){
  regexpr(",", cc) != -1})) > 0
stateTable[, whichAreNumeric] <- apply(stateTable[, whichAreNumeric], 2, function(cc){
  as.numeric(gsub(",", "", cc))})

new_theme_empty <- theme_bw()  # Create our own, mostly blank, theme
new_theme_empty$line <- element_blank()
new_theme_empty$rect <- element_blank()
new_theme_empty$strip.text <- element_blank()
new_theme_empty$axis.text <- element_blank()
#new_theme_empty$axis.title <- element_blank()
new_theme_empty$plot.margin <- structure(c(0, 0, -1, -1), unit = "lines",
                                         valid.unit = 3L, class = "unit")

stateShapes <- map("state", plot = FALSE, fill = TRUE)
stateShapes <- fortify(stateShapes)  # Load state shapefiles and convert to DF

### New stuff begins here ###

pointCollector <- list()

perNCapita <- 1000

for(ss in stateTable$State){
  print(ss)
  stateShapeFrame <- stateShapes[stateShapes$region == tolower(ss), ]
  if(nrow(stateShapeFrame) < 1){  next()  }
  statePoly <- Polygons(lapply(split(stateShapeFrame[, c("long", "lat")],
                                     stateShapeFrame$group), Polygon), ID = "b")
  nDems <- ceiling(stateTable[stateTable$State == ss, "Obama"] / perNCapita)
  nReps <- ceiling(stateTable[stateTable$State == ss, "Romney"] / perNCapita)
  nOther <- ceiling(with(stateTable[stateTable$State == ss, ],
                         Total - Romney - Obama) / perNCapita)

  pDems <- data.frame(spsample(statePoly, nDems, type = "random")@coords,
                      Vote = "Obama")
  pReps <- data.frame(spsample(statePoly, nReps, type = "random")@coords,
                      Vote = "Romney")
  if(nOther < 1){
    pOther <- data.frame(x = NULL, y = NULL, Vote = NULL)
  } else {
    pOther <- data.frame(spsample(statePoly, nOther, type = "random")@coords,
                         Vote = "Other")
    }
  allPoints <- data.frame(State = ss, rbind(pDems, pReps, pOther))
  pointCollector[[ss]] <- allPoints
}

pointFrame <- do.call(rbind, pointCollector)
# Randomize, so we don't overplot "Other" on top of "Romney" on top of "Obama."
pointFrame <- pointFrame[sample(1:nrow(pointFrame), nrow(pointFrame)), ]
head(pointFrame)

mapPlot <- ggplot(stateShapes)
mapPlot <- mapPlot + geom_point(data = pointFrame,
                                aes(x = x, y = y, colour = Vote),
                                shape = ".",
                                alpha = 1/2)
mapPlot <- mapPlot + geom_polygon(aes(x = long, y = lat, group = group),
                                  colour = "BLACK", fill = "transparent")
mapPlot <- mapPlot + coord_map(project="conic", lat0 = 30)
mapPlot <- mapPlot + new_theme_empty
mapPlot <- mapPlot + scale_colour_manual(values = c("blue", "red", "green"))
mapPlot <- mapPlot + ggtitle("2012 Election Returns by State")
mapPlot <- mapPlot + ylab("")
mapPlot <- mapPlot + xlab(paste("Each dot represents ",
                                perNCapita, " voters.", sep = ""))
mapPlot <- mapPlot + guides(colour = guide_legend(override.aes =
  list(shape = 19, alpha = 1)))
print(mapPlot)