library(googlesheets)
library(ggplot2)
library(dplyr)
library(hrbrmisc)
library(scales)

sheet <- gs_key("1wYm5waQmiYKGhtdofvXDS8SHdh72Mwcnygvf3bvFfoU")

langs <- gs_read(sheet)
langs <- langs[-(1:6), 2:4]

tops <- count(langs, parent, wt=value)

parent_cols <- c(Java="#960000", PHP="#8892bf", Python="#ffdc51", 
                 JavaScript="#70ab2d", dotNet="#68217a", Ruby="#af1401")

langs <- arrange(ungroup(mutate(group_by(langs, parent), rank=rank(value))), -rank)

langs <- mutate(group_by(langs, parent), 
                color=alpha(parent_cols[parent[1]], seq(1, 0.3, length.out=n())))

langs$parent <- factor(langs$parent, levels=arrange(tops, n)$parent)

top_f <- slice(group_by(langs, parent), 1)
top_f$color <- c("white", "white", "#2b2b2b", "#2b2b2b", "white", "white")

gg <- ggplot()
gg <- gg + geom_bar(data=langs, stat="identity", 
                    aes(x=parent, y=value, fill=color, order=rank),
                    color="white", size=0.15, width=0.65)
gg <- gg + geom_text(data=tops, family="NoyhSlim-Medium",
                     aes(x=parent, y=n, label=n), 
                     hjust=-0.2, size=3)
gg <- gg + geom_text(data=top_f, family="NoyhSlim-Medium",
                     aes(x=parent, y=value/2, label=id, color=color), 
                     hjust=0.5, size=3)
gg <- gg + scale_x_discrete(expand=c(0,0))
gg <- gg + scale_y_continuous(expand=c(0,0), limits=c(0, 900))
gg <- gg + scale_color_identity()
gg <- gg + scale_fill_identity()
gg <- gg + coord_flip()
gg <- gg + labs(x=NULL, y=NULL,
                title="Popular web frameworks using Highcharts",
                subtitle="Total usage by language, including the most popular framework in-language",
                caption="Data graciously provided by Highcharts - http://jsfiddle.net/vidarbrekke/n6pd4jfo/")
gg <- gg + theme_hrbrmstr(grid=FALSE, axis="y")
gg <- gg + theme(legend.position="none")
gg <- gg + theme(axis.text.x=element_blank())
gg
