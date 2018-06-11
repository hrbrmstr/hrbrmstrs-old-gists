library(ggplot2)

dat <- read.csv("supreme_court_vacancies.csv",
                col.names=c("year", "wait"))

# We only want every other tick labeled
xlabs <- seq(1780, 2020, by=10)
xlabs[seq(2, 24, by=2)]  <-  " "

# Pretty long caption
caption <- "Note: Vacancies are counted as the number of days between a justice's death, retirement or resignation and the successor justice's swearing in (or commissioning in the case of a recess appointment) as a member of the court.Sources: U.S. Senate, 'Supreme Court Nominations, present-1789'; Supreme Court, 'Members of the Supreme Court of the United States'; Pew Research Center calculations"
caption <- paste0(strwrap(caption, 160), sep="", collapse="\n")
# you could probably just use caption <- label_wrap_gen(160)(caption) instead

annot <- read.table(text=
"year|wait|just|text
1848|860|0|Robert Cooper Grier was sworn in Aug 10, 1846,<br>841 days after the death of Henry Baldwin
1969|440|1|Henry Blackmun was sworn<br>in June 9, 1970, 391 days<br>after Abe Fortas resigned.
1990|290|0|Anthony Kennedy<br>was sworn in Feb.<br>18, 1988, 237<br>days after Lewis<br>Powell retired.",
sep="|", header=TRUE, stringsAsFactors=FALSE)
annot$text <- gsub("<br>", "\n", annot$text)

gg <- ggplot()
gg <- gg + geom_point(data=dat, aes(x=year, y=wait))
gg <- gg + geom_label(aes(x=1780, y=900, label="days"),
                      family="OpenSans-CondensedLight",
                      size=3.5, hjust=0, label.size=0, color="#2b2b2b")
gg <- gg + geom_label(data=annot, aes(x=year, y=wait, label=text, hjust=just),
                      family="OpenSans-CondensedLight", lineheight=0.95,
                      size=3, label.size=0, color="#2b2b2b")
gg <- gg + scale_x_continuous(expand=c(0,0),
                              breaks=seq(1780, 2020, by=10),
                              labels=xlabs, limits=c(1780,2020))
gg <- gg + scale_y_continuous(expand=c(0,10),
                              breaks=seq(100, 900, by=100),
                              limits=c(0, 1000))
gg <- gg + labs(x=NULL, y=NULL,
                title="Lengthy Supreme Court vacancies are rare now, but weren't always",
                subtitle="Supreme Court vacancies, by duration",
                caption=caption)
gg <- gg + theme_minimal(base_family="OpenSans-CondensedLight")
gg <- gg + theme(panel.grid=element_line())
gg <- gg + theme(panel.grid.major.y=element_line(color="#2b2b2b", linetype="dotted", size=0.15))
gg <- gg + theme(panel.grid.major.x=element_blank())
gg <- gg + theme(panel.grid.minor.x=element_blank())
gg <- gg + theme(panel.grid.minor.y=element_blank())
gg <- gg + theme(axis.line=element_line())
gg <- gg + theme(axis.line.x=element_line(color="#2b2b2b", size=0.15))
gg <- gg + theme(axis.ticks=element_line())
gg <- gg + theme(axis.ticks.x=element_line(color="#2b2b2b", size=0.15))
gg <- gg + theme(axis.ticks.y=element_blank())
gg <- gg + theme(axis.ticks.length=unit(5, "pt"))
gg <- gg + theme(plot.margin=unit(rep(0.5, 4), "cm"))
gg <- gg + theme(axis.text.y=element_text(margin=margin(r=-5)))
gg <- gg + theme(plot.title=element_text(family="OpenSans-CondensedBold", margin=margin(b=15)))
gg <- gg + theme(plot.subtitle=element_text(family="OpenSans-CondensedLightItalic"))
gg <- gg + theme(plot.caption=element_text(size=8, hjust=0, margin=margin(t=15)))
gg
