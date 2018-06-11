library(MonetDBLite)
library(MonetDB.R)
library(dplyr)

# more likely to find a file in this format vs what dbWriteTable produces
# i.e. it has a header and commas for separator
write.csv(add_rownames(mtcars, "auto"), "mtcars.csv", row.names=FALSE)

# make a connection and get rid of the old table if it exists since
# we are just playing around. in real life you prbly want to keep
# the giant table there vs recreate it every time
mdb <- dbConnect(MonetDBLite(), "/Users/hrbrmstr/Development/monet")
try(invisible(dbSendQuery(mdb, "DROP TABLE mtcars")), silent=TRUE)

# now we guess the column types by reading in a small fraction of the rows
guess <- read.csv("mtcars.csv", stringsAsFactors=FALSE, nrows=1000)

# we build the table creation dynamically from what we've learned from guessing
create <- sprintf("CREATE TABLE mtcars ( %s )", 
                  paste0(sprintf('"%s" %s', colnames(guess), 
                                 sapply(guess, dbDataType, dbObj=mdb)), collapse=","))
invisible(dbSendQuery(mdb, create))

# and then we load the data into the database, skipping the header and specifying a comma
invisible(dbSendQuery(mdb, "COPY OFFSET 2 
                    INTO mtcars 
                    FROM '/Users/hrbrmstr/Development/mtcars.csv' USING  DELIMITERS ','"))

# now wire it up to dplyr
mdb_src <- src_monetdb(embedded="/Users/hrbrmstr/Development/monet")
mdb_mtcars <- tbl(mdb_src, "mtcars")

# and have some fun
count(mdb_mtcars, cyl)

