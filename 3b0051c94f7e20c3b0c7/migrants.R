library(SmarterPoland)
library(riverplot)
library(RColorBrewer)
library(graphics)
library(reshape2)
library(plyr)
library(stringr)
library(countrycode)

# DOWNLOAD THE DATA
df <- getEurostatRaw(kod="migr_asyappctzm")
raw <- df

# CLEAN THE DATA
temp <- unlist(strsplit(colnames(df)[1],","))
cleaned <- data.frame(str_split_fixed(df[,1],",",6))
df <- cbind(cleaned,df[,2:94])
colnames(df)[1:6] <- temp
colnames(df)[6] <- "unit"

# STRIP OUT THE BITS WE DON'T NEED
df2 <- subset(df, sex == "T" & age == "TOTAL" & !geo %in% c("EU28","TOTAL"), select=c(colnames(df)[c(1,5)],colnames(df)[7:99][grepl(2015,colnames(df)[7:99])]))
df2 <- melt(df2, id=colnames(df2)[1:2])
df2 <- df2[complete.cases(df2),]

# SUMMARISE THE NUMBERS ACCORDING TO COUNTRY OF ORIGIN
dfs <- ddply(df2, c("citizen"), summarise, num = sum(value))
dfs <- dfs[order(-dfs$num),]
dfs$citizen <- as.character(dfs$citizen)
dfs <- subset(dfs, !(citizen %in% dfs$citizen[1:2] ))

# SUMMARISE ACCORDING TO COUNTRY OF DESTINATION
dest <- ddply(df2, c("geo"), summarise, num = sum(value))
dest <- dest[order(-dest$num),]
dest$geo <- as.character(dest$geo)

# CREATE SUBSETS OF THE KEY COUNTRIES TO MAKE OUR EVENTUAL PLOT CLEANER
countries <- dfs$citizen[1:10]
destinations <- dest$geo[1:10]

# GET DATA FOR A SPECIFIC YEAR AND THEN EITHER PLOT ONLY FOR KEY ORIGINS:
#RP <- subset(df, sex == "T" & age == "TOTAL" & !geo %in% c("EU28","TOTAL") & citizen %in% countries, select=c(colnames(df)[c(1,5)],colnames(df)[7:99][grepl(2015,colnames(df)[7:99])]))

# ONLY FOR KEY DESTINATIONS:
#RP <- subset(df, sex == "T" & age == "TOTAL" & !geo %in% c("EU28","TOTAL") & geo %in% destinations, select=c(colnames(df)[c(1,5)],colnames(df)[7:99][grepl(2015,colnames(df)[7:99])]))

# OR BOTH
RP <- subset(df, sex == "T" & age == "TOTAL" & !geo %in% c("EU28","TOTAL") & citizen %in% countries & geo %in% destinations, select=c(colnames(df)[c(1,5)],colnames(df)[7:99][grepl(2015,colnames(df)[7:99])]))

# CREATE THE DATASET THAT WE WILL USE FOR OUR CHART
RP <- melt(RP, id=colnames(RP)[1:2])
RP <- RP[complete.cases(RP),]
RP$route <- paste0(RP[,1],"-",RP[,2])
RP <- ddply(RP, c("route"), summarise, from = head(citizen,1),to = head(geo,1),num = sum(value))

# THIS BIT DEFINS THE WIDTHS OF EACH SEGMENT
edges <- RP[,c(2:4)]
edges[,1] <- as.character(edges[,1])
edges[,2] <- as.character(edges[,2])
colnames(edges) <- c("N1","N2","Value")

# THIS ONE SORTS OUT WHICH SIDE OF THE CHART EACH FLOW STARTS AND ENDS
nodes = data.frame(ID = unique(c(edges$N1, edges$N2)), stringsAsFactors = FALSE)
nodes$x <- 2
nodes$x[(nodes$ID %in% countries)] <- 1

# NOW WE CAN SORT 
nodes$num <- mapply(function(x) subset(dfs, citizen == x)$num, nodes$ID)
nodes$dest <- mapply(function(x) subset(dest, geo == x)$num, nodes$ID)
nodes$set <- mapply(function(x) ifelse(x %in% countries,1,0), nodes$ID)
nodes$dest[(nodes$set==1)] <- 0
nodes$dest <- as.numeric(nodes$dest)

nodes0 <- subset(nodes, set == 0)
nodes1 <- subset(nodes, set == 1)
nodes0 <- nodes0[order(nodes0$dest),]
nodes1 <- nodes1[order(nodes1$num),]
nodes0$index <- rank(-nodes0$dest)
nodes1$index <- rank(-nodes1$num)
nodes <- rbind(nodes1,nodes0)

row.names(nodes) <- NULL

# GET CONTINENTS FOR ORIGIN COLOURS
nodes1$cont <- countrycode(nodes1$ID,"iso2c","continent")

# I HAPPEND TO KNOW IT WON'T PICK UP KOSOVO, SO:
nodes1$cont[(nodes1$ID == "XK")] <- "Europe" 

# SET UP COLOURS FOR SANKEY CHART
# length(unique(nodes1$cont))
conts <- unique(nodes1$cont)
contsC <- c("firebrick2","darkgoldenrod1","chartreuse3")
p1 <- mapply(function(x) contsC[(conts==x)], nodes1$cont)
p2 <- rep("dodgerblue3",nrow(nodes0))
palette <- c(p1,p2)
styles = lapply(as.numeric(row.names(nodes)), function(n) {
  list(col = palette[n], lty = 0, textcol = "black")
})
names(styles) = nodes$ID

# DRAW THE CHART :-)
rp <- makeRiver(nodes,edges,node_styles=styles)
riverplot(rp,node_margin=0.025,plot_area=0.9)
