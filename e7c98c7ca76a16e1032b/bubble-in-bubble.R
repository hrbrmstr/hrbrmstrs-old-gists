circle <- function(center, radius, group) {
  th <- seq(0, 2*pi, len=200)
  data.frame(group=group,
             x=center[1] + radius*cos(th),
             y=center[2] + radius*sin(th))
}

obs <- c(`Odyssey`=132000, `Haven`=145000, `Amoco Cadiz`=223000, 
         `Castillo de Bellver`=252000, `ABT Summer`=260000, 
         `Nowruz oil field`=260000, `Fergana Valley`=285000, 
         `Empress`=287000, `Ixtoc I oil well`=54000)#, 
         # `Gulf War oil spill`=1500000)
obs <- as.list(rev(sort(obs)))

rads <- lapply(obs, "/", 2)

x <- max(sapply(rads, "["))

do.call(rbind.data.frame, lapply(1:length(rads), function(i) {
  circle(c(x, rads[[i]]), rads[[i]], names(rads[i]))
})) -> dat

gg <- ggplot(dat)
gg <- gg + geom_polygon(aes(x=x, y=y, group=group, fill=group), 
                        color="black", size=0.25)
gg <- gg + coord_equal()
gg <- gg + guides(fill=guide_legend(override.aes=list(colour=NA)))
gg <- gg + scale_fill_manual(name="Oil Spills", values=brewer.pal(length(obs), "Set1"))
gg <- gg + ggthemes::theme_map()
gg <- gg + theme(legend.position="right")
gg

