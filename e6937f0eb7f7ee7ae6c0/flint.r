library(sp)
library(maptools)
library(rgeos)
library(rgdal)
library(tigris)
library(ggplot2)
library(ggthemes)
library(viridis)
library(dplyr)
library(scales)

mi <- zctas(cb=TRUE, starts_with=c("4850", "4853", "4852", "4851"))
mi_map <- fortify(mi)
zctas_border <- fortify(unionSpatialPolygons(mi, rep(1, 10)))

flint <- read.csv("https://gist.githubusercontent.com/hrbrmstr/e6937f0eb7f7ee7ae6c0/raw/e93fa23d8a03bc81e5089c278463224efe50154c/flinth2o.csv",
                  stringsAsFactors=FALSE)

flint$brk <- cut(flint$lead_ppb,
                 breaks=c(0, 0.99, 4, 14, 49, 149, 100000),
                 labels=c("0", "1-4", "5-14", "15-49", "50-149", "150+"),
                 right=FALSE)

gg <- ggplot()
gg <- gg + geom_map(data=mi_map, map=mi_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", fill="#f0f0f0", size=0.15)
gg <- gg + geom_map(data=zctas_border, map=zctas_border,
                    aes(x=long, y=lat, map_id=id),
                    color="black", fill=NA, size=0.5)
gg <- gg + geom_point(data=flint, 
                      aes(x=Longitude, y=Latitude, fill=brk), 
                      shape=21, color="black", size=1.5)
gg <- gg + scale_fill_viridis(name="Lead range (ppb)", discrete=TRUE, option="A")
gg <- gg + coord_map()
gg <- gg + theme_map()
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(legend.position="right")
gg

flint_2 <- bind_cols(flint, over(SpatialPoints(coordinates(flint[,c("Longitude", "Latitude")]), CRS(proj4string(mi))), mi))

flint_grp <- count(flint_2, GEOID10, lead_ppb)
action <- mutate(summarise(mutate(group_by(flint_grp, GEOID10), action=lead_ppb>=15), total=sum(n), action_ct=sum(action), pct=action_ct/total, pct_lab=percent(pct)), pct_lab=ifelse(pct_lab=="NaN%", "0%", pct_lab))

gg <- ggplot(action)
gg <- gg + geom_bar(aes(x=reorder(GEOID10, -pct), y=pct), stat="identity")
gg <- gg + geom_text(aes(x=reorder(GEOID10, -pct), y=pct, 
                         label=sprintf("  %s (%d)", pct_lab, action_ct)), hjust=0, size=3)
gg <- gg + scale_x_discrete(expand=c(0,0))
gg <- gg + scale_y_continuous(expand=c(0,0), limits=c(0, 0.08))
gg <- gg + coord_flip()
gg <- gg + labs(x=NULL, y=NULL)
gg <- gg + theme_tufte(base_family="Helvetica")
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(axis.text.x=element_blank())
gg
