library(purrr)
library(tidyr)
library(jsonlite)
library(readr)
library(httr)
library(V8)
library(data.table)
library(dplyr)
library(scales)
library(ggplot2)
library(ggthemes)

# it takes a bit of effort to get the data out
res <- GET("http://www.healthmap.org/flutrends/getdata.php",
           add_headers(`Referer`="http://www.healthmap.org/flutrends/",
                       `X-Requested-With`="XMLHttpRequest"),
           user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.48 Safari/537.36"))

# and it's in javascript, not JSON so we have to use V8
ct <- v8()
ct$eval(sprintf("var flu = %s", content(res, as="text")))
dat <- ct$get("flu")

# the resultant list has 11 matricies O_o
# we need to fix that. element 1 is "the world"
map(dat, function(x) {
  d <- as.data.frame(x, stringsAsFactors=FALSE)
  type_convert(setNames(d, as.vector(d[1,]))[2:nrow(d),],
               na=c("X", "NA"))
}) -> dat
names(dat) <- c("world", 1:10)

# elements 2:11 are the 10 US CDC regions

# we need things in long format for optimal use
world_flu <- dat[[1]]
world_flu <- gather(world_flu, estimate_source, value, -week)
world_flu <- mutate(world_flu, value=value/100)

# rbindlist can add the list index col name (w00t!)
us_flu <- as.data.frame(rbindlist(dat[2:11], idcol="us_region"))
us_flu <- gather(us_flu, estimate_source, value, -us_region, -week)
us_flu <- mutate(us_flu, value=value/100)

# a sample vis
gg <- ggplot(filter(world_flu, !grepl("^Ensemble", estimate_source)))
gg <- gg + stat_identity(aes(x=week, y=value,
                             group=estimate_source,
                             color=estimate_source),
                         geom="line",
                         size=0.25)
gg <- gg + scale_x_date(expand=c(0,0))
gg <- gg + scale_y_continuous(expand=c(0,0), label=percent)
gg <- gg + scale_color_tableau(name="Source")
gg <- gg + labs(x=NULL, y=NULL, title="World Flu Forecast")
gg <- gg + theme_bw()
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(legend.position="bottom")
gg