library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(grid)
library(statebins)
library(gridExtra)

# http://www.washingtonpost.com/wp-srv/special/investigative/asset-seizures/data/all.json

# grab the data from WaPo #####

data <- jsonlite::fromJSON("~/Desktop/all.json", simplifyVector=FALSE)

# grab census state population data #####

pop <- read.csv("http://www.census.gov/popest/data/state/asrh/2013/files/SCPRC-EST2013-18+POP-RES.csv", stringsAsFactors=FALSE)
colnames(pop) <- c("sumlev", "region", "divison", "state", "stn", "pop2013", "pop18p2013", "pcntest18p")
pop$stn <- gsub(" of ", " Of ", pop$stn)

# get totals by category even though we're not using them for the vis #####

categories <- rbindlist(lapply(data$states, function(x) {
  data.table(st=x$st, stn=x$stn, total=x$total, rbindlist(x$cats))
}), fill=TRUE)


# get totals by agencies #####

agencies <- rbindlist(lapply(data$states, function(x) {
  rbindlist(lapply(x$agencies, function(y) {
    data.table(st=x$st, stn=x$stn, aid=y$aid, aname=y$aname, rbindlist(y$cats))
  }), fill=TRUE)
}), fill=TRUE)


# summarize the agency data to the state level #####

c_st <- agencies %>%
  merge(pop[,5:6], all.x=TRUE, by="stn") %>%
  gather(category, value, -st, -stn, -pop2013, -aid, -aname) %>%
  group_by(st, category, pop2013) %>%
  summarise(total=sum(value, na.rm=TRUE), per_capita=sum(value, na.rm=TRUE)/pop2013) %>%
  select(st, category, total, per_capita)

# hack to ordering the bars by kohske : http://stackoverflow.com/a/5414445/1457051 #####

c_st <- transform(c_st, category2=factor(paste(st, category)))
c_st <- transform(c_st, category2=reorder(category2, rank(-total)))

# pretty names #####

levels(c_st$category) <- c("Weapons", "Travel, training", "Other",
                           "Communications, computers", "Building improvements",
                           "Electronic surveillance", "Information, rewards",
                           "Salary, overtime", "Community programs")

# plot totals w/o considerig per-capita #####

gg <- ggplot(c_st, aes(x=category2, y=total))
gg <- gg + geom_bar(stat="identity", aes(fill=category))
gg <- gg + scale_y_continuous(labels=dollar)
gg <- gg + scale_x_discrete(labels=c_st$st, breaks=c_st$category2)
gg <- gg + facet_wrap(~category, scales = "free", ncol=1)
gg <- gg + labs(x="", y="")
gg <- gg + theme_bw()
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_text(size=15, face="bold"))
gg <- gg + theme(panel.margin=unit(2, "lines"))
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(axis.text.x=element_text(size=9))
gg <- gg + theme(legend.position="none")
gg

ggsave(filename="raw-large.png", plot=gg, height=15, width=11, dpi=600)

# change bar order to match per-capita calcuation #####

c_st <- transform(c_st, category2=reorder(category2, rank(-per_capita)))

# per-capita bar plot #####

gg <- ggplot(c_st, aes(x=category2, y=per_capita))
gg <- gg + geom_bar(stat="identity", aes(fill=category))
gg <- gg + scale_y_continuous(labels=dollar)
gg <- gg + scale_x_discrete(labels=c_st$st, breaks=c_st$category2)
gg <- gg + facet_wrap(~category, scales = "free", ncol=1)
gg <- gg + labs(x="", y="")
gg <- gg + theme_bw()
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(strip.text=element_text(size=15, face="bold"))
gg <- gg + theme(panel.margin=unit(2, "lines"))
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(axis.text.x=element_text(size=9))
gg <- gg + theme(legend.position="none")
gg

ggsave(filename="capita-large.png", plot=gg, height=15, width=11, dpi=600)

# now do it statebins-style (per-capita) #####

st_pl <- vector("list", 1+length(unique(c_st$category)))

j <- 0
for (i in unique(c_st$category)) {
  j <- j + 1
  png(filename=sprintf("statebins%03d.png", j), width=600, height=600, units="px", type="quartz")
  print(statebins_continuous(c_st[category==i,], state_col="st", value_col="per_capita") +
    scale_fill_gradientn(labels=dollar, colours=brewer.pal(6, "PuBu"), name=i) +
    theme(legend.key.width=unit(2, "cm")))
  dev.off()
#   st_pl[[j]] <- statebins_continuous(c_st[category==i,], state_col="st", value_col="per_capita") +
#     scale_fill_gradientn(labels=dollar, colours=brewer.pal(6, "PuBu"), name=i) +
#     theme(legend.key.width=unit(2, "cm"))
}
st_pl[[1+length(unique(c_st$category))]] <- list(ncol=1)

grid.arrange(st_pl[[1]], st_pl[[2]], st_pl[[3]],
             st_pl[[4]], st_pl[[5]], st_pl[[6]],
             st_pl[[7]], st_pl[[8]], st_pl[[9]], ncol=3)