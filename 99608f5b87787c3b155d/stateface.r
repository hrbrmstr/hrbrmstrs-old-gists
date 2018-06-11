library(dplyr)    # munging
library(ggplot2)  # plotting, req: devtools::intstall_github("hadley/ggplot2")
library(scales)   # plotting helpers
library(hrbrmisc) # my themes

# read in exceedance state/county data
dat <- read.csv("http://rud.is/dl/h2olead.csv", stringsAsFactors=FALSE)

# this is how USA TODAY's computation works, I'm just following it
xcd <- count(distinct(dat, state, county, name), state, wt=exceedances)

# get U.S. state population estimates for 2015
us_pop <- setNames(read.csv("http://www.census.gov/popest/data/state/totals/2015/tables/NST-EST2015-01.csv",
                            skip=9, nrows=51, stringsAsFactors=FALSE, header=FALSE)[,c(1,9)],
                   c("state_name", "pop"))
us_pop$state_name <- sub("^\\.", "", us_pop$state_name)
us_pop$pop <- as.numeric(gsub(",", "", us_pop$pop))

# join them to the exceedance data
state_tbl <- data_frame(state_name=state.name, state=tolower(state.abb))
us_pop <- left_join(us_pop, state_tbl)
xcd <- left_join(xcd, us_pop)

# compute the exceedance by 100k population & order the
# states by that so we get the right bar order in ggplot
xcd$per100k <- (xcd$n / xcd$pop) * 100000
xcd$state_name <- factor(xcd$state_name,
                         levels=arrange(xcd, per100k)$state_name)
xcd <- arrange(xcd, desc(state_name))

# get the top 10 worse exceedances
top_10 <- head(xcd, 10)

# map (heh) the stateface font glpyh character to the state 2-letter code
state_trans <- c(AL='B', AK='A', AZ='D', AR='C', CA='E', CO='F', CT='G', 
                 DE='H', DC='y', FL='I', GA='J', HI='K', ID='M', IL='N', 
                 IN='O', IA='L', KS='P', KY='Q', LA='R', ME='U', MD='T',
                 MA='S', MI='V', MN='W', MS='Y', MO='X', MT='Z', NE='c',
                 NV='g', NH='d', NJ='e', NM='f', NY='h', NC='a', ND='b', 
                 OH='i', OK='j', OR='k', PA='l', RI='m', SC='n', SD='o',
                 TN='p', TX='q', UT='r', VT='t', VA='s', WA='u', WV='w', 
                 WI='v', WY='x', US='z')
top_10$st <- state_trans[toupper(top_10$state)]


gg <- ggplot(top_10, aes(x=state_name, y=per100k))
gg <- gg + geom_bar(stat="identity", width=0.75)

# here's what you need to do to place the stateface glyphs
gg <- gg + geom_text(aes(x=state_name, y=0.25, label=st),
                     family="StateFace-Regular", color="white",
                     size=5, hjust=0)

gg <- gg + geom_text(aes(x=state_name, y=per100k,
                         label=sprintf("%s total  ", comma(n))),
                     hjust=1, color="white", family="KerkisSans", size=3.5)
gg <- gg + scale_x_discrete(expand=c(0,0))
gg <- gg + scale_y_continuous(expand=c(0,0))
gg <- gg + coord_flip()
gg <- gg + labs(x=NULL, y=NULL,
                title="Lead in the water: A nationwide look; Top 10 impacted states",
                subtitle="Exceedance count adjusted per 100K population; total exceedance displayed",
                caption="Data from USA TODAY's compliation of EPA’s Safe Drinking Water Information System (SDWIS) database.")

# you'll need the Kerkis font loaded to use this theme
# http://myria.math.aegean.gr/kerkis/
gg <- gg + theme_hrbrmstr_kerkis(grid=FALSE)

# I neee to fiddle with the theme settings so these line height tweaks
# aren't necessary in the future
gg <- gg + theme(plot.caption=element_text(lineheight=0.7))
gg <- gg + theme(plot.title=element_text(lineheight=0.7))

gg <- gg + theme(axis.text.x=element_blank())
gg <- gg + theme(panel.margin=margin(t=5, b=5, l=20, r=20, "pt"))
gg


