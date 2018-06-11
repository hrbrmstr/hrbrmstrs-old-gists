library(ggbeeswarm)
library(hrbrmisc)
library(tidyverse)

cran_rox_df <- readRDS("cran_rox_df.rds")

ggplot(cran_rox_df, aes(rox_vers, pkg_age)) +
  geom_quasirandom(alpha=1/2, size=2, shape=21, stroke=0.35, fill="#f6e8c3", color="#1a1a1abb") +
  scale_y_continuous(breaks=seq(0, 7300, 1825), limits=c(0, 7300),
                     labels=c("0", "5", "10", "15", "20\nyrs")) +
  labs(x="Roxygen2 version", y="Overall package age since first release",
       title="Distribution of Roxygen2 version use by overall package age") +
  theme_hrbrmstr_msc(grid="Y") -> g1

ggplot(cran_rox_df, aes(rox_vers, days_since_last_cran)) +
  geom_quasirandom(alpha=1/2, size=2, shape=21, stroke=0.35, fill="#f6e8c3", color="#1a1a1abb") +
  scale_y_continuous(breaks=c(0, 182, 365, 547), limits=c(0, 547),
                     labels=c("0 days", "6 mos", "1 yr", "1.5 yrs")) +
  labs(x="Roxygen2 version", y="Days since last CRAN release",
       title="Distribution of Roxygen2 version use by days since last CRAN release") +
  theme_hrbrmstr_msc(grid="Y") -> g2

cowplot::plot_grid(g1, g2, ncol=1, align="v")
