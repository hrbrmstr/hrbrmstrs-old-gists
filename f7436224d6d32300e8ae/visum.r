library(ggplot2)
library(gridExtra)
library(ggthemes)
library(scales)
library(grid)
library(dplyr)

vsum <- function(df,
                 cont=c("d", "h", "b", "v", "dens", "hist", "box", "violin"),
                 bins=30) {

  cont <- match.arg(cont, c("d", "h", "b", "v", "dens", "hist", "box", "violin"))
  cont <- substring(cont, 1, 1)

  n <- ncol(df)

  lapply(1:n, function(i) {

    col <- as.list(df)[[i]]
    nam <- colnames(df)[i]

    if (class(col) %in% c("numeric", "double", "integer")) {

      gg <- ggplot(data.frame(x=col))
      if (cont == "d") {
        gg <- gg + geom_density(aes(x=x, y=..count..),
                                fill="maroon", color="#2b2b2b", alpha=0.9, size=0.25)
      } else if (cont=="h") {
        gg <- gg + geom_histogram(aes(x=x), bins=bins,
                                  fill="maroon", color="#2b2b2b", alpha=0.9, size=0.25)
      } else if (cont=="b") {
        gg <- gg + geom_boxplot(aes(x=1, y=x), width=0.9,
                                fill="maroon", color="#2b2b2b", alpha=0.9, size=0.25)
      } else if (cont=="v") {
        gg <- gg + geom_violin(aes(x=1, y=x), width=0.9, draw_quantiles = c(0.25, 0.5, 0.75),
                              fill="maroon", color="#2b2b2b", alpha=0.9, size=0.25)
      }

      if (cont %in% c("b", "v")) {
        gg <- gg + scale_x_continuous(expand=c(0,0))
        gg <- gg + scale_y_continuous(breaks=range(col))
        gg <- gg + coord_flip()
      } else {
        gg <- gg + scale_x_continuous(breaks=range(col))
        gg <- gg + scale_y_continuous(expand=c(0,0))
      }
      gg <- gg + labs(x=NULL, y=NULL, title=nam)
      gg <- gg + theme_tufte(base_family="Arial")
      gg <- gg + theme(plot.title=element_text(hjust=0, face="bold", size=7))
      gg <- gg + theme(axis.ticks=element_blank())
      gg <- gg + theme(panel.grid=element_line(color="#2b2b2b", size=0.15))
      gg <- gg + theme(panel.margin=unit(2, "cm"))

      if (cont %in% c("b", "v")) {
        gg <- gg + theme(axis.text.x=element_text(hjust=c(0, 1), size=7))
        gg <- gg + theme(axis.text.y=element_blank())
      } else {
        gg <- gg + theme(axis.text.x=element_text(hjust=c(0, 1), size=7))
        gg <- gg + theme(axis.text.y=element_text(size=7))
      }
      gg

    } else if (class(col) %in% c("factor", "character", "logical")) {

      if (class(col) %in% c("character", "logical")) {
        col <- factor(col)
      }

      xtab <- as.data.frame(table(col))
      brks <- c(0, round(max(xtab$Freq)/2), max(xtab$Freq))

      gg <- ggplot(xtab)

      if (nrow(xtab) > 15) {
        gg <- gg + geom_bar(aes(x=reorder(col, Freq), y=Freq), stat="identity",
                            color="white", fill="maroon", width=0.5, size=0.01)
        txty <- element_blank()
      } else {
        gg <- gg + geom_bar(aes(x=reorder(col, Freq), y=Freq), stat="identity",
                            color="white", fill="maroon", alpha=0.9, size=0.5)
        txty <- element_text(size=7)
      }
      gg <- gg + scale_x_discrete(expand=c(0,0))
      gg <- gg + scale_y_continuous(expand=c(0,0), breaks=brks)
      gg <- gg + coord_flip()
      gg <- gg + labs(x=NULL, y=NULL, title=nam)
      gg <- gg + theme(panel.grid=element_line(color="#2b2b2b", size=0.15))
      gg <- gg + theme(panel.margin=unit(2, "cm"))
      gg <- gg + theme_tufte(base_family="Arial")
      gg <- gg + theme(axis.ticks=element_blank())
      gg <- gg + theme(axis.text.x=element_text(hjust=c(0, 0.5, 1), size=7))
      gg <- gg + theme(axis.text.y=txty)
      gg <- gg + theme(plot.title=element_text(hjust=0, face="bold", size=7))
      gg

    }

  }) -> lst

  do.call(grid.arrange, c(lst, ncol=4))

}

# mutate(mtcars,
#        cyl=factor(cyl),
#        vs=factor(vs),
#        am=factor(am),
#        gear=factor(gear),
#        carb=factor(carb)) -> mtc2

# vsum(mtcars, "h")
# vsum(mtc2, "d")
# vsum(mtc2, "h")
# vsum(mtc2, "b")
vsum(mtc2, "v")
# vsum(iris)
# vsum(dat)
