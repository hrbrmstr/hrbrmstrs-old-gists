---
title: "Mass. Power Outages"
author: "hrbrmstr"
date: "`r Sys.Date()`"
output: hrbrmrkdn::default
---
```{r, echo = FALSE}
knitr::opts_chunk$set(collapse=TRUE,
                      fig.retina=2)
```
One of the power companies in Mass. was kind enough to use a mapping service that makes the power outage data easily available. We'll need some pacakes for this.

```{r message=FALSE, warning=FALSE}
library(maptools)  # geo stuff
library(rgeos)     # moar geo stuff
library(rgdal)     # even moar geo stuff
library(ggplot2)   # best plotting evar
library(ggthemes)  # good themes
library(ggalt)     # better projections
library(viridis)   # better colors
library(scales)    # formatting
```

This is an "empty" shapefile that contains the data about the power service status in each town. 

```{r}
outage_url <- "http://mema.mapsonline.net/power_outage_public.geojson"
ma_outages <- suppressWarnings(readOGR(outage_url, "OGRGeoJSON", 
                      verbose=FALSE, stringsAsFactors=FALSE))
```

You can see what it hold by looking at the `data` slot:

```{r}
dplyr::glimpse(ma_outages@data)
```

Now we need some county and town maps. Mass. gov provides those (and they are shockingly decent). We conver them to lat/lon so it speeds up `coord_proj` and/or `coord_map`. And, we download them in such a way as to cache them and not re-download them every time.

```{r}
cnty_url <- "http://wsgw.mass.gov/data/gispub/shape/state/counties.zip"
cnty_fil <- basename(cnty_url)
if (!file.exists(cnty_fil)) download.file(cnty_url, cnty_fil)
unzip(cnty_fil)
counties <- readOGR("COUNTIES_POLY.shp", "COUNTIES_POLY", 
                    verbose=FALSE, stringsAsFactors=FALSE)
counties <- SpatialPolygonsDataFrame(spTransform(counties, CRS("+proj=longlat")),
                                     counties@data)

twn_url <- "http://wsgw.mass.gov/data/gispub/shape/state/towns.zip"
twn_fil <- basename(twn_url)
if (!file.exists(twn_fil)) download.file(twn_url, twn_fil)
unzip(twn_fil)
towns <- readOGR("TOWNS_POLY.shp", "TOWNS_POLY",
                 verbose=FALSE, stringsAsFactors=FALSE)
towns <- SpatialPolygonsDataFrame(spTransform(towns, CRS("+proj=longlat")),
                                     towns@data)
```

We need those polygons in a format we can use with ggplot2, so we "fortify" them (turn the complex `SpatialPolygonsDataFrame`s into a plain old `data.frame`) using the county and town names as a way to index the polygons.

```{r}
counties_map <- fortify(counties, region="COUNTY")
towns_map <- fortify(towns, region="TOWN")
```

This is the projection most folks are used to when they see a Mass. map:

```{r}
ma_proj <- "+proj=lcc +lat_1=41.71666666666667 +lat_2=42.68333333333333 +lat_0=41 +lon_0=-71.5 +x_0=200000 +y_0=750000 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"
```

Now, we plot the map. First we lay down the towns, then fill in the towns with outages, then lay down the county borders.

```{r fig.width=10, fig.height=6}
gg <- ggplot()
gg <- gg + geom_map(map=towns_map, data=towns_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#7f7f7f", fill=NA, size=0.15)
gg <- gg + geom_map(map=towns_map, data=ma_outages@data,
                    aes(fill=pct_nopow, map_id=town), 
                    color="white", size=0.15)
gg <- gg + geom_map(map=counties_map, data=counties_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", fill=NA, size=0.5)
gg <- gg + scale_fill_viridis(name="% w/o\nPower", labels=percent)
gg <- gg + coord_proj(ma_proj)
gg <- gg + labs(title="Mass. Power Outages", 
                x=sprintf("%s total w/o power", 
                          comma(sum(ma_outages@data$no_power))))
gg <- gg + theme_map()
gg <- gg + theme(legend.position="right")
gg <- gg + theme(axis.title=element_text())
gg <- gg + theme(axis.title.y=element_blank())
gg <- gg + theme(plot.title=element_text(hjust=0, size=16, face="bold"))
gg
```

Every time you re-run this you'll get new outage data. You could even write a script that grabs the outage data regularly and tracks it over time.

You can find the source code for this Rmd in [this gist](https://gist.github.com/hrbrmstr/97f87a794effe8e21185).

```{r bib, include=FALSE}
knitr::write_bib(sub("^package:", "", grep("package", search(), value=TRUE)), file='skeleton.bib')
```
