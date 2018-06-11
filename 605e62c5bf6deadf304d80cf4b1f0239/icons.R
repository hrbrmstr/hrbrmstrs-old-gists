library(Cairo) # better anti-aliasing
library(showtext) # required
font.add("cam", "cambriaz.TTF")
showtext.auto()

set.seed(1)
xlm <- c(-4.5, 4.5)
x <- seq(xlm[1], xlm[2], length=1000)
y <- dnorm(x)
x2 <- rnorm(500000)
x2 <- x2[x2 > xlm[1] & x2 < xlm[2]]
mar <- c(0.1, 0.1, 0.1 ,0.1)

# Code is repetetive and includes hardcoded values because each icon is uniquely tailored,
# for example, for proper text placement.
# To run accompanying Shiny app, run this script to generate the icons and place them in the app's
# www/ directory.
makeIcons <- function(primary_color="#FFFFFF", secondary_color="#FFFFFF75", color_theme="white"){
  # distribution icons
  CairoPNG(paste0("stat_icon_normal_dist_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(x, y, type="n", axes=FALSE, xlab="", ylab="", xlim=xlm)
  hist(x2, breaks=seq(xlm[1], xlm[2], by=1), freq=FALSE, add=TRUE, border=primary_color)
  lines(x, y, col=primary_color)
  dev.off()
  
  CairoPNG(paste0("stat_icon_normal_mean_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(x, y, type="n", axes=FALSE, xlab="", ylab="", xlim=xlm)
  hist(x2, breaks=seq(xlm[1], xlm[2], by=1), freq=FALSE, add=TRUE, border=secondary_color)
  lines(x, y, col=secondary_color)
  abline(v=0, lwd=3, lty=2, col=primary_color)
  legend("topright", legend=expression(bolditalic(bar(x))), bty ="n", pch=NA, cex=3,  yjust=1, adj=c(-0.5, 0), text.col=primary_color)
  dev.off()
  
  CairoPNG(paste0("stat_icon_normal_min_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(x, y, type="n", axes=FALSE, xlab="", ylab="", xlim=xlm)
  hist(x2, breaks=seq(xlm[1], xlm[2], by=1), freq=FALSE, add=TRUE, border=secondary_color)
  lines(x, y, col=secondary_color)
  abline(v=xlm[1], lwd=3, lty=2, col=primary_color)
  legend("topright", legend=expression(bolditalic(x[(1)])), bty ="n", pch=NA, cex=1.8, adj=c(-0.275, 0), text.col=primary_color)
  dev.off()
  
  CairoPNG(paste0("stat_icon_normal_max_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(x, y, type="n", axes=FALSE, xlab="", ylab="", xlim=xlm)
  hist(x2, breaks=seq(xlm[1], xlm[2], by=1), freq=FALSE, add=TRUE, border=secondary_color)
  lines(x, y, col=secondary_color)
  abline(v=xlm[2], lwd=3, lty=2, col=primary_color)
  legend("topleft", legend=expression(bolditalic(x[(n)])), bty ="n", pch=NA, cex=1.8,  adj=c(1, 0), text.col=primary_color)
  dev.off()
  
  CairoPNG(paste0("stat_icon_normal_median_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(x, y, type="n", axes=FALSE, xlab="", ylab="", xlim=xlm)
  hist(x2, breaks=seq(xlm[1], xlm[2], by=1), freq=FALSE, add=TRUE, border=secondary_color)
  lines(x, y, col=secondary_color)
  abline(v=0, lwd=3, lty=2, col=primary_color)
  legend("topright", legend=expression(bolditalic(tilde(x))), bty ="n", pch=NA, cex=3,  adj=c(-0.5, 0), text.col=primary_color)
  dev.off()
  
  CairoPNG(paste0("stat_icon_normal_sd_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(x, y, type="n", axes=FALSE, xlab="", ylab="", xlim=xlm)
  hist(x2, breaks=seq(xlm[1], xlm[2], by=1), freq=FALSE, add=TRUE, border=secondary_color)
  lines(x, y, col=secondary_color)
  abline(v=c(-1,1), lwd=3, lty=2, col=primary_color)
  legend("topright", legend=expression(bolditalic(s)), bty="n", pch=NA, cex=3, adj=c(-0.5, 0), text.col=primary_color)
  dev.off()
  
  showtext.auto(enable=FALSE)
  
  CairoPNG(paste0("stat_icon_boxplot_iqr_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  boxplot(x2, outline=FALSE, axes=FALSE, frame=FALSE,  lty=1, border=secondary_color, boxcol=primary_color)
  text(1.35, -0.05, expression("}"), cex=2, col=primary_color)
  showtext.begin()
  text(1.35, 1.5, expression("IQR"), cex=1.5, col=primary_color)
  showtext.end()
  dev.off()
  
  showtext.auto()
  
  # time series icons
  y <- scale(c(0.3,0.4,2,0.7,2,1.5,3.5,2.75,4))
  x <- scale(seq_along(y))
  
  CairoPNG(paste0("stat_icon_ts_deltaDec_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(0,0, type="n", axes=FALSE, xlab="", ylab="", xlim=range(x), ylim=range(y))
  lines(x, rev(y), lty=2, col=secondary_color)
  arrows(x[1], y[length(y)], x[length(x)], y[1], lwd=3, col=primary_color)
  legend("topright", legend=expression(bolditalic(Delta)), bty ="n", pch=NA, cex=1.8, adj=c(-0.75, 0), text.col=primary_color)
  dev.off()
  
  CairoPNG(paste0("stat_icon_ts_deltaInc_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(0,0, type="n", axes=FALSE, xlab="", ylab="", xlim=range(x), ylim=range(y))
  lines(x, y, lty=2, col=secondary_color)
  arrows(x[1], y[1], x[length(x)], y[length(y)], lwd=3, col=primary_color)
  legend("topleft", legend=expression(bolditalic(Delta)), bty ="n", pch=NA, cex=1.8,  adj=c(2.5, 0), text.col=primary_color)
  dev.off()
  
  CairoPNG(paste0("stat_icon_ts_deltaPctDec_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(0,0, type="n", axes=FALSE, xlab="", ylab="", xlim=range(x), ylim=range(y))
  lines(x, rev(y), lty=2, col=secondary_color)
  arrows(x[1], y[length(y)], x[length(x)], y[1], lwd=3, col=primary_color)
  legend("topright", legend=expression(bolditalic(symbol("\045")~Delta)), bty ="n", pch=NA, cex=1.8, adj=c(-0.25, 0), text.col=primary_color)
  dev.off()
  
  CairoPNG(paste0("stat_icon_ts_deltaPctInc_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  plot(0,0, type="n", axes=FALSE, xlab="", ylab="", xlim=range(x), ylim=range(y))
  lines(x, y, lty=2, col=secondary_color)
  arrows(x[1], y[1], x[length(x)], y[length(y)], lwd=3, col=primary_color)
  legend("topleft", legend=expression(bolditalic(symbol("\045")~Delta)), bty ="n", pch=NA, cex=1.8,  adj=c(0.9, 0), text.col=primary_color)
  dev.off()
  
  # bar icons
  CairoPNG(paste0("stat_icon_bar_deltaNeg_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  barplot(c(4,1), axes=FALSE, lty=1, border=primary_color, col=secondary_color)
  arrows(1.6, 4, 1.6, 1.2, lwd=3, col=primary_color)
  legend("topright", legend=expression(bolditalic(Delta)), bty ="n", pch=NA, cex=1.8, adj=c(-0.5, 0), text.col=primary_color)
  dev.off()
  
  CairoPNG(paste0("stat_icon_bar_deltaPos_", color_theme, ".png"), width=96, height=96, bg="transparent")
  par(lwd=2, mar=mar, family="cam")
  barplot(c(1,4), axes=FALSE, lty=1, border=primary_color, col=secondary_color)
  arrows(1, 1.2, 1, 4, lwd=3, col=primary_color)
  legend("topleft", legend=expression(bolditalic(Delta)), bty ="n", pch=NA, cex=1.8, adj=c(2.5, 0), text.col=primary_color)
  dev.off()
}

makeIcons()
makeIcons("black", "gray30", "black")
