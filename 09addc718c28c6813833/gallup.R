library(reshape2)
library(ggplot2)
library(scales)
library(RColorBrewer)

dat <- read.table(text="Crime Frequently Occassionally Rarely_Never Does_not_apply rank
Credit_card_hacked 41 28 29 2 1
Computer_smartphone_hacked 34 28 35 4 2 
Home_burglarized_not_present 18 27 55 1 3 
Car_stolen_not_present 15 27 56 2 4 
Child_attacked_at_school 13 18 48 20 5
Victim_of_terrorism 11 17 72 0 6 
Getting_mugged 11 20 69 0 7
Home_burglarized_present 9 21 70 0 8
Victim_of_hate_crime 7 11 81 0 9
Sexually_assaulted 7 11 82 0 10
Attacked_while_driving_car 5 15 76 3 11
Getting_murdered 5 13 81 0 12 
Assaulted_killed_at_work 3 4 85 8 13", header=TRUE, stringsAs=FALSE)

dat$Crime <- gsub("_", " ", dat$Crime)
dat$Crime <- factor(dat$Crime, dat$Crime, ordered=TRUE)
dat_m <- melt(dat, id.vars = c("Crime", "rank"))
colnames(dat_m) <- c("Crime", "Rank", "Response", "Value")

gg <- ggplot(dat_m, aes(x=Response, y=Value))
gg <- gg + geom_bar(stat="identity", aes(fill=Response))
gg <- gg + scale_fill_brewer(palette="BrBG", type="div")
gg <- gg + coord_flip()
gg <- gg + facet_wrap(~Crime)
gg <- gg + theme_bw()
gg

gg <- ggplot(dat_m, aes(x=Crime, y=Value, fill=Response))
gg <- gg + geom_bar(position="fill", stat="identity")
gg <- gg + scale_y_continuous(labels = percent_format(), expand=c(0,0))
gg <- gg + scale_fill_brewer(palette="BrBG", type="div")
gg <- gg + coord_flip()
gg <- gg + labs(x=NULL, y=NULL)
gg <- gg + theme_bw()
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg