library(ggplot2)
library(dplyr)
library(gridExtra)

pres <- structure(list(last_name = c("Washington", "Adams", "Jefferson",
"Madison", "Monroe", "Adams", "Jackson", "VanBuren", "Harrison",
"Tyler", "Polk", "Taylor", "Filmore", "Pierce", "Buchanan", "Lincoln",
"Johnson", "Grant", "Hayes", "Garfield", "Arthur", "Cleveland",
"Harrison", "Cleveland", "McKinley", "Roosevelt", "Taft", "Wilson",
"Harding", "Coolidge", "Hoover", "Roosevelt", "Truman", "Eisenhower",
"Kennedy", "Johnson", "Nixon", "Ford", "Carter", "Reagan", "Bush",
"Clinton", "Bush"), days_in_office = c(2864L, 1460L, 2921L, 2921L,
2921L, 1460L, 2921L, 1460L, 31L, 1427L, 1460L, 491L, 967L, 1460L,
1460L, 1503L, 1418L, 2921L, 1460L, 199L, 1260L, 1460L, 1460L,
1460L, 1655L, 2727L, 1460L, 2921L, 881L, 2039L, 1460L, 4452L,
2810L, 2922L, 1036L, 1886L, 2027L, 895L, 1461L, 2922L, 1461L,
2922L, 1110L)), .Names = c("last_name", "days_in_office"), class = "data.frame", row.names = c(NA,
-43L))

grid.arrange(

  ggplot(pres, aes(x="Presidents", y=days_in_office)) +
    geom_boxplot() +
    labs(x=NULL, title="boxplot"),

  ggplot(pres, aes(x="Presidents", y=days_in_office)) +
    geom_boxplot() +
    geom_jitter() +
    labs(x=NULL, title="box+jitter"),

  ggplot(pres, aes(x=days_in_office)) +
    geom_histogram(binwidth=1000, color="white") +
    scale_y_continuous(expand=c(0,0)) +
    scale_x_continuous(expand=c(0,0), limits=c(0, 5000)) +
    labs(title="histogram"),

  ggplot(pres, aes(x=days_in_office)) +
    geom_density() +
    labs(title="density"),

  ggplot(pres, aes(x="Presidents", y=days_in_office)) +
    geom_violin() +
    labs(title="violin"),

  ggplot(pres, aes(x="Presidents", y=days_in_office)) +
    geom_violin() +
    geom_boxplot(alpha=0) +
    labs(x=NULL, title="violin+box"),

  ggplot(pres, aes(x="Presidents", y=days_in_office)) +
    geom_violin() +
    geom_boxplot(alpha=0) +
    geom_jitter() +
    labs(x=NULL, title="violin+box+jitter"),

  ggplot(pres, aes(x=days_in_office)) +
    geom_dotplot(method="histodot", binwidth=100) +
    scale_y_continuous(name = "", breaks = NULL) +
    labs(title="dotplot"),

  ncol=2

)
