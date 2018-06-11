library(RCurl)
library(RJSONIO)
library(ggplot2)

# get data formats from: http://www.bls.gov/help/hlpforma.htm
# this one is "Average Hourly Earnings of All Employees: Private Service-Providing (CEU0800000003)"

bls.content <- getURLContent("http://api.bls.gov/publicAPI/v1/timeseries/data/CEU0800000003")
bls.json <- fromJSON(bls.content, simplify=TRUE)
bls.df <- data.frame(year=sapply(bls.json$Results[[1]]$series[[1]]$data,"[[","year"),
                     period=sapply(bls.json$Results[[1]]$series[[1]]$data,"[[","period"),
                     periodName=sapply(bls.json$Results[[1]]$series[[1]]$data,"[[","periodName"),
                     value=as.numeric(sapply(bls.json$Results[[1]]$series[[1]]$data,"[[","value")), 
                     stringsAsFactors=FALSE)

ggplot(data=bls.df, aes(x=34:1, y=value)) + geom_line()
