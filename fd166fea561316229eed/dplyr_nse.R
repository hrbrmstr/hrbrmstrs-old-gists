library(dplyr)
library(ggplot2)
library(lazyeval)

data(mpg)

# "normal" dplyr
a <- mpg %>% mutate(hwybin=replace(hwy>25,1,0))


# varying just the RHS
varname <- "hwy"
b <- mpg %>% mutate_(hwybin=interp(~replace(varname>25, 1 ,0),
                                   varname=as.name(varname)))

identical(a, b)


# varying both RHS and LHS
colname <- "hwybin"
z <- mpg %>% mutate_(.dots=setNames(list(interp(~replace(varname>25, 1 ,0),
                            varname=as.name(varname))), colname))

# tests
identical(a, b)
identical(a, z)
identical(b, z)
