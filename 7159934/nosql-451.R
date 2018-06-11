library(ggplot)

nosql.df <- read.csv("nosql.csv", header=TRUE)
nosql.df$Database <- factor(nosql.df$Database,
                            levels=c("MongoDB","Cassandra","Redis","HBase","CouchDB",
                                     "Neo4j","Riak","MarkLogic","Couchbase","DynamoDB"))

gg <- ggplot(data=nosql.df, aes(x=Quarter, y=Index))
gg <- gg + geom_point(aes(color=Quarter), size=3)
gg <- gg + facet_grid(Database~.)
gg <- gg + coord_flip()
gg <- gg + theme_bw()
gg <- gg + labs(x="", title="NoSQL LinkedIn Skills Index\nSeptember 2013")
gg <- gg + theme(legend.position = "none")
gg <- gg + theme(strip.text.x = element_blank())
gg