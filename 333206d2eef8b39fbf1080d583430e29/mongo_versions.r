#' ---
#' output:
#'   html_document:
#'     theme: simplex
#'     highlight: espresso
#'     keep_md: true
#' ---
#+ message=FALSE
library(tidyverse)
library(hrbrmisc)

structure(list(mm = c("1.5", "1.6", "1.6", "1.8", "1.8", "2.0",
"2.0", "2.1", "2.1", "2.2", "2.2", "2.3", "2.4", "2.4", "2.5",
"2.5", "2.6", "2.6", "2.7", "2.7", "2.8", "3.0", "3.0", "3.1",
"3.1", "3.2", "3.2", "3.3", "3.3", "3.4", "3.4", "3.5", "3.5"
), is_compromised = c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE,
FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE), n = c(-201, 205,
-278, 214, -348, 299, -1301, 202, -208, 282, -806, 201, 741,
-6754, 201, -204, 1172, -5785, 204, -217, -203, 1171, -4663,
202, -235, 2142, -8099, 227, -290, 959, -1537, 201, -204), v = c(1.5,
1.6, 1.6, 1.8, 1.8, 2, 2, 2.1, 2.1, 2.2, 2.2, 2.3, 2.4, 2.4,
2.5, 2.5, 2.6, 2.6, 2.7, 2.7, 2.8, 3, 3, 3.1, 3.1, 3.2, 3.2,
3.3, 3.3, 3.4, 3.4, 3.5, 3.5), nend = c(-200, 200, -200, 200,
-200, 200, -200, 200, -200, 200, -200, 200, 200, -200, 200, -200,
200, -200, 200, -200, -200, 200, -200, 200, -200, 200, -200,
200, -200, 200, -200, 200, -200), col = c("End of Life", "End of Life",
"End of Life", "End of Life", "End of Life", "End of Life", "End of Life",
"End of Life", "End of Life", "End of Life", "End of Life", "End of Life",
"End of Life", "End of Life", "End of Life", "End of Life", "End of Life",
"End of Life", "End of Life", "End of Life", "Still Supported",
"Still Supported", "Still Supported", "Still Supported", "Still Supported",
"Still Supported", "Still Supported", "Still Supported", "Still Supported",
"Still Supported", "Still Supported", "Still Supported", "Still Supported"
)), class = c("tbl_df", "tbl", "data.frame"), .Names = c("mm",
"is_compromised", "n", "v", "nend", "col"), row.names = c(NA,
-33L)) -> mongo_df

#+ mongo_versions, fig.width=13, fig.height=5, fig.retina=2
mutate(mongo_df, actual_n=abs(n)-200) %>%
  group_by(mm) %>%
  mutate(pct=actual_n/sum(actual_n), pct_lab=scales::percent(pct)) %>%
  mutate(hjust=ifelse(n<0, 1, 0)) %>%
  mutate(nudge=ifelse(n<0, -100, 100)) %>%
  mutate(full_lab=ifelse(n<0,
                         sprintf("(%s) %s", pct_lab, scales::comma(actual_n)),
                         sprintf("%s (%s)", scales::comma(actual_n), pct_lab)
                         )) %>%
  ggplot(aes(n, mm)) +
  geom_label(aes(x=0, y=mm, label=mm), family="MuseoSansCond-300", size=4, label.size=0) +
  geom_label(data=data_frame(y=c("1.6", "2.2", "2.6", "3.2"), x=c(4000, 4000, 4000, 4000),
                             lab=c("2010 (release year)", 2012, 2014, 2016)),
             aes(x=x, y=y, label=lab), hjust=0.5, family="MuseoSansCond-500") +
  geom_segment(aes(xend=nend, yend=mm, color=col), size=1, show.legend=FALSE) +
  geom_point(aes(color=col), size=2) +
  geom_label(aes(x=n+nudge, y=mm, label=full_lab, hjust=hjust), label.size=0, size=3, family="MuseoSansCond-100") +
  scale_x_continuous(expand=c(0,0), position="top", breaks=c(-1000, 0, 1000), limits=c(-9000, 4750),
                     labels=c("← Compromised/ransomed", "MongoDB\nVersion", "Not-compromised/ransomed →")) +
  scale_color_manual(name=NULL, values=c(`End of Life`="#d73027", `Still Supported`="#4575b4")) +
  labs(x=NULL, y=NULL, caption="Source: Rapid7 Project Sonar") +
  theme_hrbrmstr_msc(grid="") +
  theme(axis.text.y=element_blank()) +
  theme(axis.text.x=element_text(family=c("Arial Narrow", "MuseoSansCond-700", "Arial Narrow"),
                                 size=c(10, 12, 10), hjust=c(1, 0.5, 0))) +
  theme(legend.position=c(0.35, 1.03)) +
  theme(legend.direction="horizontal")
