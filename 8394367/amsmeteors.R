library(XML)
library(plyr)

observations <- readHTMLTable("http://www.amsmeteors.org/observations/", which=1)

observations$Altitude <- gsub("[m,]", "", observations$Altitude)
observations$Altitude <- gsub("-", "0", observations$Altitude)

observations$Location = gsub("\\s", "", observations$Location)
observations$Location = gsub("°", "", observations$Location)

lat.lon.df <- ldply(strsplit(observations$Location, ","))
colnames(lat.lon.df) <- c("Latitude", "Longitude")

observations <-  cbind(observations, lat.lon.df)

observations$Location <- NULL

# replace stdout() with a file
write.csv(observations, stdout(), row.names=FALSE)