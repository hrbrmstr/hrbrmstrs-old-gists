library(ggplot2)

apple_watch <- function(filename="watch.png", 
                        size=38, bg="transparent", 
                        pointsize=12) {
  if (size %in% c(38, 42)) {
    ppi  <- if (size==38) 330 else 333
    width  <- if (size==38) 272 else 312
    height  <- if (size==38) 340 else 390
    png(filename=filename,
        width, height,
        pointsize=pointsize, bg=bg,
        res=326, type="quartz")
  }
}

awc <- c("#e2122c","#52df2c", "#26d4da", "#03b8ff", "#ffed25")

fitness <- data.frame(
  activity=c("calories", "moving", "standing"),
  pct=c(0.3, 0.5, 0.1),
  colors=c("#e2122c","#52df2c", "#26d4da")
) 

ggplot(fitness) + 
  annotate("text", label="Fitness", color="white", size=3,
           x=Inf, y=0.5, vjust=1.25) +
  geom_bar(aes(x=activity, y=pct, fill=colors), width=0.75, stat="identity") +
  scale_y_continuous(expand=c(0,0), limits=c(0, 1)) +
  scale_x_discrete(expand=c(0,1)) +
  scale_fill_identity() +
  coord_flip() +
  labs(x=NULL, y=NULL, title=NULL, subtitle=NULL, caption=NULL) +
  theme(title=element_blank()) +
  theme(text=element_blank()) +
  theme(axis.text=element_text(margin=margin(0,0,0,0,"null"))) +
  theme(axis.text.x=element_text(margin=margin(0,0,0,0,"null"))) +
  theme(axis.text.y=element_text(margin=margin(0,0,0,0,"null"))) +
  theme(axis.ticks=element_blank()) +
  theme(axis.ticks.x=element_blank()) +
  theme(axis.ticks.y=element_blank()) +
  theme(axis.ticks.length=unit(0, "null")) +
  theme(panel.grid=element_blank()) +
  theme(plot.margin=margin(0,0,0,0,"null")) +
  theme(panel.margin=margin(0,0,0,0,"null")) +
  theme(panel.margin.x=unit(0, "null")) +
  theme(panel.margin.y=unit(0, "null")) +
  theme(plot.background=element_rect(color="black", fill="black")) +
  theme(panel.background=element_rect(color="black", fill="black")) +
  theme(legend.position="none") -> gg

apple_watch("activity.png", 42)
gg
dev.off()