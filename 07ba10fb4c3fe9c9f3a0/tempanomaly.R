library(httr)
library(magrittr)
library(dplyr)
library(ggplot2)

# data retrieval ----------------------------------------------------------

pg <- GET("http://data.giss.nasa.gov/gistemp/tabledata_v3/GLB.Ts+dSST.txt",
          user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A"))

# extract monthly data ----------------------------------------------------

content(pg, as="text") %>%
  strsplit("\n") %>%
  extract2(1) %>%
  grep("^[[:digit:]]", ., value=TRUE) -> lines

# extract column names ----------------------------------------------------

content(pg, as="text") %>%
  strsplit("\n") %>%
  extract2(1) %>%
  extract(8) %>%
  strsplit("\ +") %>%
  extract2(1) -> lines_colnames

# make data frame ---------------------------------------------------------

data <- read.table(text=lines, stringsAsFactors=FALSE)
colnames(data) <- lines_colnames

# transform data frame ----------------------------------------------------

data %>%
  tidyr::gather(month, value, Jan, Feb, Mar, Apr, May, Jun,
                       Jul, Aug, Sep, Oct, Nov, Dec) %>%     # wide to long
  mutate(value=value/100) %>%                                # convert to degree Celcius change
  select(year=Year, month, value) %>%                        # only need these fields
  mutate(date=as.Date(sprintf("%d-%d-%d", year, month, 1)),  # make proper dates
         decade=year %/% 10,                                 # calc decade
         start=decade*10, end=decade*10+9) %>%               # calc decade start/end
  group_by(decade) %>%
    mutate(decade_mean=mean(value)) %>%                      # calc decade mean
  group_by(year) %>%
    mutate(annum_mean=mean(value)) %>%                       # calc annual mean
  ungroup -> data

# start plot --------------------------------------------------------------

gg <- ggplot()

# decade vertical markers -------------------------------------------------

gg <- gg + geom_vline(data=data %>% select(end),
                      aes(xintercept=as.numeric(as.Date(sprintf("%d-12-31", end)))),
                          size=0.5, color="#4575b4", linetype="dotted", alpha=0.5)

# monthly data ------------------------------------------------------------

gg <- gg + geom_line(data=data, aes(x=date, y=value, color="monthly anomaly"),
                     size=0.35, alpha=0.25)
gg <- gg + geom_point(data=data, aes(x=date, y=value, color"monthly anomaly"),
                      size=0.75, alpha=0.5)

# decade mean -------------------------------------------------------------

gg <- gg + geom_segment(data=data %>% distinct(decade, decade_mean, start, end),
                        aes(x=as.Date(sprintf("%d-01-01", start)),
                            xend=as.Date(sprintf("%d-12-31", end)),
                            y=decade_mean, yend=decade_mean,
                            color="decade mean anomaly"),
                        linetype="dashed")

# annual data -------------------------------------------------------------

gg <- gg + geom_line(data=data %>% distinct(year, annum_mean),
                      aes(x=as.Date(sprintf("%d-06-15", year)), y=annum_mean,
                          color="annual mean anomaly"),
                      size=0.5)
gg <- gg + geom_point(data=data %>% distinct(year, annum_mean),
                      aes(x=as.Date(sprintf("%d-06-15", year)), y=annum_mean,
                          color="annual mean anomaly"),
                      size=2)

# additional annotations --------------------------------------------------

# max annual mean anomaly horizontal marker/text

gg <- gg + geom_hline(yintercept=max(data$annum_mean),  alpha=0.9,
                      color="#d73027", linetype="dashed", size=0.25)

gg <- gg + annotate("text",
                    x=as.Date(sprintf("%d-12-31", mean(range(data$year)))),
                    y=max(data$annum_mean),
                    color="#d73027", alpha=0.9,
                    hjust=0.25, vjust=-1, size=3,
                    label=sprintf("Max annual mean anomaly %2.1fºC", max(data$annum_mean)))

gg <- gg + geom_hline(yintercept=max(data$value),  alpha=0.9,
                      color="#7f7f7f", linetype="dashed", size=0.25)

# max annual anomaly horizontal marker/text

gg <- gg + annotate("text",
                    x=as.Date(sprintf("%d-12-31", mean(range(data$year)))),
                    y=max(data$value),
                    color="#7f7f7f",  alpha=0.9,
                    hjust=0.25, vjust=-1, size=3,
                    label=sprintf("Max annual anomaly %2.1fºC", max(data$value)))

gg <- gg + annotate("text",
                    x=as.Date(sprintf("%d-12-31", range(data$year)[2])),
                    y=min(data$value), size=3, hjust=1,
                    label="Data: http://data.giss.nasa.gov/gistemp/tabledata_v3/GLB.Ts+dSST.txt")

# set colors --------------------------------------------------------------

gg <- gg + scale_color_manual(name="", values=c("#d73027", "#4575b4", "#7f7f7f"))

# set x axis limits -------------------------------------------------------

gg <- gg + scale_x_date(expand=c(0, 1),
                        limits=c(as.Date(sprintf("%d-01-01", range(data$year)[1])),
                                 as.Date(sprintf("%d-12-31", range(data$year)[2]))))

# add labels --------------------------------------------------------------

gg <- gg + labs(x=NULL, y="GLOBAL Temp Anomalies in 1.0ºC",
                title=sprintf("GISS Land and Sea Temperature Annual Anomaly Trend (%d to %d)\n",
                              range(data$year)[1], range(data$year)[2]))

# theme/legend tweaks -----------------------------------------------------

gg <- gg + theme_bw()
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(legend.position=c(0.9, 0.2))
gg <- gg + theme(legend.key=element_blank())
gg <- gg + theme(legend.background=element_blank())
gg
