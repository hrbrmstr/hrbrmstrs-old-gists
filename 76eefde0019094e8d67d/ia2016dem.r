---
title: "2016 Iowa Democratic Caucus Results"
author: "hrbrmstr"
date: "`r Sys.Date()`"
output: hrbrmrkdn::bulma
---

Code in [this gist](https://gist.github.com/hrbrmstr/76eefde0019094e8d67d).

`devtools::install_github("hrbrmstr/hrbrmrkdn")`

```{r message=FALSE}
library(rgeos)
library(sp)
library(maptools)
library(tigris)
library(purrr)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(ggalt)
library(gridExtra)
library(jsonlite)

URL <- 'https://www.idpcaucuses.com/api/countycandidateresults'
dat <- fromJSON(URL, flatten = TRUE)

map2_df(dat$CountyResults$Candidates,
        dat$CountyResults$County.FIPSCode,
  function(x, y) {
    bind_cols(x, data_frame(FIPS=gsub("^19", "", rep(y, nrow(x)))))
  }
) -> candidates

iowa <- counties("IA")

iowa_map <- fortify(iowa, region="COUNTYFP")

wins <- filter(candidates, IsWinner)

gg <- ggplot()
gg <- gg + geom_map(data=iowa_map, map=iowa_map,
                    aes(x=long, y=lat, map_id=id),
                    color="white", fill=NA, size=0.15)
gg <- gg + geom_map(data=wins, map=iowa_map,
                    aes(fill=Candidate.LastName, map_id=FIPS),
                    color="white", size=0.15)
gg <- gg + scale_fill_tableau(name="Candidate")
gg <- gg + coord_proj("+proj=aea +lat_1=40.843637240198944 +lat_2=43.033040132526075 +lon_0=-93.460693359375")
gg <- gg + theme_map(base_family="Helvetica")
gg <- gg + theme(legend.position="none")

iowa_gg <- gg

gg <- ggplot(count(wins, Candidate.LastName))
gg <- gg + stat_identity(aes(x=Candidate.LastName, y=n, fill=Candidate.LastName),
                         geom="bar")
gg <- gg + stat_identity(aes(x=Candidate.LastName, y=n, 
                             fill=Candidate.LastName, label=sprintf("%d  ", n)),
                         geom="text", hjust=1, color="white")
gg <- gg + coord_flip()
gg <- gg + labs(x=NULL, y="# Counties")
gg <- gg + scale_x_discrete(expand=c(0,0))
gg <- gg + scale_y_continuous(expand=c(0,0))
gg <- gg + scale_fill_tableau(name="Candidate")
gg <- gg + theme_tufte(base_family="Helvetica")
gg <- gg + theme(legend.position="none")
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(axis.text.x=element_blank())

iowa_ctys <- gg
```

```{r fig.retina=2, fig.width=7, fig.height=7}
grid.arrange(iowa_gg, iowa_ctys, ncol=1, heights=c(0.8, 0.2))
```


```{r bib, include=FALSE}
# KEEP THIS AT THE END OF THE DOCUMENT TO GENERATE A LOCAL bib FILE FOR PKGS USED
knitr::write_bib(sub("^package:", "", grep("package", search(), value=TRUE)), file='skeleton.bib')
```
