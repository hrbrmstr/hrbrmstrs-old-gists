library(ggplot2)
library(plyr)

# need to run this in your project directory:
# git log --pretty=format:"%cd" | sed -e 's/\:/\ /' | \
#     cut -f 1,4 -d\  | sort | uniq -c | \
#     sed -e 's/^\ \ *//' > /tmp/timecard.out

base.df <- expand.grid(dow=c("Sun","Mon","Tue","Wed","Thu", "Fri","Sat"), hour=0:23)
base.df$dow <- factor(base.df$dow, levels=c("Sun","Mon","Tue","Wed","Thu", "Fri","Sat"))

commits.df <- read.csv("/tmp/timecard.out", sep=" ")
colnames(commits.df) <- c("count", "dow", "hour")
commits.df$dow <- factor(commits.df$dow, levels=c("Sun","Mon","Tue","Wed","Thu", "Fri","Sat"))

all <- join(base.df,commits.df)

gg <- ggplot(data=all, aes(x=hour, y=dow))
gg <- gg + geom_tile(aes(fill=count), color="gray60",alpha=0.9)
gg <- gg + scale_fill_gradient(limits=c(0,10),low="#EDF8FB",high="#005824",na.value="white")
gg <- gg + labs(x="", y="", title="'git' Commits")
gg <- gg + theme_bw()
gg <- gg + theme(panel.background=element_blank())
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg
