library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library(scales)
library(gridExtra)
library(grid)

# use the NPR story data file ---------------------------------------------
# and be kind to NPR's bandwidth budget
url <- "http://apps.npr.org/dailygraphics/graphics/women-cs/data.csv"
fil <- "gender.csv"
if (!file.exists(fil)) download.file(url, fil)

gender <- read.csv(fil, stringsAsFactors=FALSE)

# take a look at the CSV structure ----------------------------------------

glimpse(gender)

tail(gender)

# via http://apps.npr.org/dailygraphics/graphics/women-cs/js/graphic.js
# there are 'tk' values in the data set that should be ignored so
# replace them with NA by ensuring all columns are numeric.
# also the color values came from that javascript file, too.

gender <- mutate_each(gender, funs(as.numeric))

# make better column labels for display -----------------------------------

colnames(gender) <- str_replace(colnames(gender), "\\.", " ")

gender_long <- mutate(gather(gender, area, value, -date),
                      area=factor(area, levels=colnames(gender)[2:5],
                                  ordered=TRUE))

gender_colors <- c('#11605E', '#17807E', '#8BC0BF','#D8472B')
names(gender_colors) <- colnames(gender)[2:5]

# Here’s a “normal” ggplot ------------------------------------------------
# styled similar to the NPR plot but it's not straightforward to
# do the left-aligned title and subtitle with styling so center it is!

chart_title <- expression(atop("What Happened To Women In Computer Science?",
                               atop(italic("% Of Women Majors, By Field"))))

gg <- ggplot(gender_long)
gg <- gg + geom_line(aes(x=date, y=value, group=area, color=area))
gg <- gg + scale_color_manual(name="", values=gender_colors)
gg <- gg + scale_y_continuous(label=percent)
gg <- gg + labs(x=NULL, y=NULL, title=chart_title)
gg <- gg + theme_bw(base_family="Helvetica")
gg <- gg + theme(axis.ticks.y=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(legend.key=element_blank())
gg

# now to label end of the lines -------------------------------------------

last_vals <- sapply(colnames(gender)[2:5], function(x) last(na.exclude(gender[,x])))
last_date <- tail(gender$date)+1 # doing this ^ wld have made it a double

gg <- gg + theme(legend.position="none")
gg <- gg + theme(plot.margin = unit(c(1, 7, 2, 1), "lines"))

for (i in 1:length(last_vals)) {
  gg <- gg + annotation_custom(grob=textGrob(names(last_vals)[i], hjust=0,
                                             gp=gpar(fontsize=8, 
                                                     col=gender_colors[names(last_vals)[i]])),
                               xmin=2014, xmax=2014,
                               ymin=last_vals[i], ymax=last_vals[i])
}

gb <- ggplot_build(gg)
gt <- ggplot_gtable(gb)

gt$layout$clip[gt$layout$name=="panel"] <- "off"
grid.draw(gt)
