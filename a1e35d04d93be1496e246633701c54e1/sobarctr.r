read.table(text="X6,X15_7
not specified,don't agree
turkish,agree
other,agree
other,better not
turkish,rather yes
turkish,rather yes
other,agree
turkish,agree
not specified,rather yes
russian,don't agree
other,don't agree
other,don't agree
turkish,don't agree
other,better not
turkish,agree
russian,rather yes
turkish,don't agree
other,agree
other,agree
other,agree
russian,better not
russian,better not
other,better not
russian,don't agree
not specified,better not
russian,rather yes", quote="", sep=",", header=TRUE, stringsAsFactors=FALSE) -> df

library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

arrange(df, X6, X15_7) %>% 
  count(X6, X15_7) %>% 
  group_by(X6) %>% 
  mutate(tot=sum(n),
         pos=cumsum(n)-0.5*n,
         lab=percent(n/tot)) -> df_p

p <- ggplot(df_p, aes(x=X6, y=n, fill=X15_7))
p <- p + geom_bar(stat="identity", position="stack")
p <- p + geom_text(aes(y=pos, label=lab), size=3)
p <- p + theme(legend.position="none")
p <- p + coord_flip()
p
