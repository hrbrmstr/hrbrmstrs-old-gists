library(ggplot2)
library(grid)
library(scales)
library(hrbrmisc) # devtools::install_github("hrbrmstr/hrbrmisc")
library(tidyr)
 
dat <- read.table(text=
"Task|less_than_one_hour_per_week|one_to_four_hours_per_week|one_to_three_hours_a_day|four_or_more_hours_a_day
Basic exploratory data analysis|11|32|46|12
Data cleaning|19|42|31|7
Machine learning, statistics|34|29|27|10
Creating visualizations|23|41|29|7
Presenting analysis|27|47|20|6
Extract, transform, load|43|32|20|5", sep="|", header=TRUE, stringsAsFactors=FALSE)
 
amount_trans <- c("less_than_one_hour_per_week"="<1 hr/\nwk", 
                  "one_to_four_hours_per_week"="1-4 hrs/\nwk", 
                  "one_to_three_hours_a_day"="1-3 hrs/\nday", 
                  "four_or_more_hours_a_day"="4+ hrs/\nday")
 
dat <- gather(dat, amount, value, -Task)
dat$value <- dat$value / 100
dat$amount <- factor(amount_trans[dat$amount], levels=amount_trans)
 
title_trans <- c("Basic exploratory data analysis"="Basic exploratory\ndata analysis", 
                 "Data cleaning"="Data\ncleaning", 
                 "Machine learning, statistics"="Machine learning,\nstatistics", 
                 "Creating visualizations"="Creating\nvisualizations", 
                 "Presenting analysis"="Presenting\nanalysis", 
                 "Extract, transform, load"="Extract,\ntransform, load")
 
dat$Task <-factor(title_trans[dat$Task], levels=title_trans)
 
gg <- ggplot(dat, aes(x=amount, y=value, fill=amount))
gg <- gg + geom_bar(stat="identity", width=0.75, color="#2b2b2b", size=0.05)
gg <- gg + scale_y_continuous(expand=c(0,0), labels=percent, limits=c(0, 0.5))
gg <- gg + scale_x_discrete(expand=c(0,1))
gg <- gg + scale_fill_manual(name="", values=c("#a6cdd9", "#d2e4ee", "#b7b079", "#efc750"))
gg <- gg + facet_wrap(~Task, scales="free")
gg <- gg + labs(x=NULL, y=NULL, title="Where Does the Time Go?")
gg <- gg + theme_hrbrmstr(grid="Y", axis="x", plot_title_margin=9)
gg <- gg + theme(panel.background=element_rect(fill="#efefef", color=NA))
gg <- gg + theme(strip.background=element_rect(fill="#858585", color=NA))
gg <- gg + theme(strip.text=element_text(family="OpenSans-CondensedBold", size=12, color="white", hjust=0.5))
gg <- gg + theme(panel.margin.x=unit(1, "cm"))
gg <- gg + theme(panel.margin.y=unit(0.5, "cm"))
gg <- gg + theme(legend.position="none")
gg <- gg + theme(panel.grid.major.y=element_line(color="#b2b2b2"))
gg <- gg + theme(axis.text.x=element_text(margin=margin(t=-10)))
gg <- gg + theme(axis.text.y=element_text(margin=margin(r=-10)))
 
ggplot_with_subtitle(gg, 
                     "The amount of time spent on various tasks by surveyed non-managers in data-science positions.",
                     fontfamily="OpenSans-CondensedLight", fontsize=12, bottom_margin=16)