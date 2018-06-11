library(plotly)
library(bupaR)
library(tidyverse)

# get the unique nodes
patients <- mutate(patients, employee = toupper(employee))

nodes <- sort(unique(c(as.character(patients$employee), as.character(patients$handling))))

count(patients, employee, handling) %>%                       # count pairs 
  complete(employee, handling, fill=list(n=0)) %>%            # have an entry for each pair combo
  mutate(employee = factor(employee, levels=nodes)) %>%       # these two lines
  mutate(handling = factor(handling, levels=nodes)) -> sdf    # make it possible to get numeric values for the nodes

list(
  type = "sankey",
  domain = c(
    x =  c(0,1),
    y =  c(0,1)
  ),
  node = list(label = nodes),
  link = list(
    source = as.numeric(sdf$employee)-1, 
    target = as.numeric(sdf$handling)-1, 
    value = sdf$n,
    label = sprintf("Case%d", 1:nrow(sdf))
  )
) -> trace1

plot_ly(
  domain=trace1$domain, link=trace1$link,
  node=trace1$node, type=trace1$type
)