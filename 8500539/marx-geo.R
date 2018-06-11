library(data.table)
library(bit64)

# data.table is a wicked fast data.frame compatible object
# and fread() is a wicked fast file reader that behaves
# like read.csv(). it's even faster and more efficient if
# we provide a row count (estimate) so we do that here

marx <- fread("marx-geo.csv", nrows=451582, sep=",", header=TRUE)

# we only need lat/lon columns so we subset the data.table
# on those columns, remove any missing coordinate pairs
# and only retrieve unique pairs (since it's not important
# for this map demo to have duplicate points)

write.csv(unique(na.omit(marx[,14:15,with=FALSE])), "latlon.csv", row.names=FALSE)