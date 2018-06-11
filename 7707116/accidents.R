# install.packages("data.table") # if you don't have it installed

library(data.table)

# download the file first since it's *huge* and we don't want to have to
# re-download it every time we work with it. comment this out after you
# read it in once or put an "if exists" wrapper around it to avoid
# re-downloading it from an errant script run. This assumes you have
# a "data"directory under your home directory; change destination
# as appropriate

download.file("http://fimi.ua.ac.be/data/accidents.dat", "~/data/accidents.dat")

# it's a wretched file format, so we need to get max # of possible columns
# since read.table (et al) will only scan the first 5 lines to get field count

max.fields <- max(count.fields("~/data/accidents.dat", sep=" "))

# now read it in (you can use better column names if you want) and
# use a data.table since it will really help speed up further
# operations on this data table

accidents.df <- data.table(read.table("~/data/accidents.dat",
                                      sep=" ", header=FALSE, fill=TRUE,
                                      col.names=1:max.fields))

# take a look at the data

summary(accidents.df)
