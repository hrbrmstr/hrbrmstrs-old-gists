# via R-bloggers post

library(Rmpfr)
library(circlize)
library(viridis)

CreateAdjacencyMatrix <- function(x) {

  s <- gsub("\\.", "", x)
  m <- matrix(0, 10, 10)

  for (i in 1:(nchar(s)-1)) {
    m[as.numeric(substr(s, i, i))+1,
      as.numeric(substr(s, i+1, i+1))+1] <-
      m[as.numeric(substr(s, i, i))+1,
        as.numeric(substr(s, i+1, i+1))+1]+1

  }

  rownames(m) = 0:9
  colnames(m) = 0:9

  m

}

m1 = CreateAdjacencyMatrix(formatMpfr(Const("pi",2000)))

jpeg(filename = "Chords.jpg", width = 800, height = 800, quality = 100)
par(mfrow=c(1,1), mar = c(1, 1, 1, 1))
chordDiagram(m1, grid.col = "darkgreen",
             col = colorRamp2(quantile(m1, seq(0, 1, by = 0.25)), viridis(5)),
             transparency = 0.4, annotationTrack = c("name", "grid"))

dev.off()
