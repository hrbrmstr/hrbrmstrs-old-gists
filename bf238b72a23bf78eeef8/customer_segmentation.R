---
title: "Customer Segmentation in R (Riffing off of @YhatHQ's Python Post) #rstats"
author: "Bob Rudis (@hrbrmstr)"
output:
  html_document:
    theme: spacelab
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE,
                      collapse = TRUE,
                      fig.retina = 2,
                      warning = FALSE,
                      message = FALSE,
                      error = FALSE)
library(pander)
library(DT)
```

Greg, over at&nbsp; $\hat{y}hat$, did a [really nice job](http://blog.yhathq.com/posts/customer-segmentation-using-python.html) introducing basic K-Means clustering with Principal Component Analysis to look at commonalities between sets of customers.

I thought it would be interesting to have an R-verison of it available in the event someone wanted to see a comparison of the solution between the two languages (and, it's a really compact example that I might be able to use in the classes I'm teaching at some point).

You'll need to keep [their post handy](http://blog.yhathq.com/posts/customer-segmentation-using-python.html) since I'm only riffing off of them, not pilfering their content or idea (and they deserve your eyeballs as they contribute quite a bit to the data science community on a regular basis).

## The Data

We'll start by reading in the same data set, but first we'll load some pacakges we'll need to help us with the analyses &amp; visualizations:

```{r pkgs}
library(readxl)    # free data from excel hades
library(dplyr)     # sane data manipulation
library(tidyr)     # sane data munging
library(viridis)   # sane colors
library(ggplot2)   # needs no introduction
library(ggfortify) # super-helpful for plotting non-"standard" stats objects
```

>NOTE: To use `ggfortify` you'll need to `devtools::install_github("sinhrks/ggfortify)` since it's not in CRAN.

Now, we'll read in the file, taking care to only download it once from the&nbsp; $\hat{y}hat$ servers:

```{r dl}
url <- "http://blog.yhathq.com/static/misc/data/WineKMC.xlsx"
fil <- basename(url)
if (!file.exists(fil)) download.file(url, fil)
```

Reading in and cleaning up the sheets looks _really_ similar to the Python example:

```{r rd1}
offers <- read_excel(fil, sheet = 1)
colnames(offers) <- c("offer_id", "campaign", "varietal", "min_qty", "discount", "origin", "past_peak")
```
```{r rd1_hd, eval=FALSE}
head(offers)
```
```{r rd1_hd_pander, echo=FALSE}
pander(head(offers))
```
```{r rd2}
transactions <- read_excel(fil, sheet = 2)
colnames(transactions) <- c("customer_name", "offer_id")
transactions$n <- 1
```
```{r rd2_hd, eval=FALSE}
head(transactions)
```
```{r rd2_hd_pander, echo=FALSE}
pander(head(transactions))
```

The `dplyr` package offers a very SQL-esque way of manipulating data and&mdash;combined with the `tidyr` package&mdash;makes quick work of getting the data into the the binary wide-form we need:

```{r munge}
# join the offers and transactions table
left_join(offers, transactions, by="offer_id") %>% 
# get the number of times each customer responded to a given offer
  count(customer_name, offer_id, wt=n) %>%
# change it from long to wide
  spread(offer_id, n) %>%
# and fill in the NAs that get generated as a result
  mutate_each(funs(ifelse(is.na(.), 0, .))) -> dat
```

## Clustering our customers

With the data in shape we can perform the same K-Means clustering:

```{r clus1}
fit <- kmeans(dat[,-1], 5, iter.max=1000)
```
```{r clus1_tab, eval=FALSE}
table(fit$cluster)
```
```{r clus1_pander, echo=FALSE}
pander(table(fit$cluster))
```
```{r clus1_barplot}
barplot(table(fit$cluster), col="maroon")
```

## Visualizing the clusters

The same Principal Component Analysis to get the scatterplot:

```{r pcamds}
pca <- prcomp(dat[,-1])
pca_dat <- mutate(fortify(pca), col=fit$cluster)
ggplot(pca_dat) +
  geom_point(aes(x=PC1, y=PC2, fill=factor(col)), size=3, col="#7f7f7f", shape=21) +
  scale_fill_viridis(name="Cluster", discrete=TRUE) + theme_bw(base_family="Helvetica")
```

We can use the handy `autoplot` feature of `ggfortify` to do all that for us, tho:

```{r kmeans_pca}
autoplot(fit, data=dat[,-1], frame=TRUE, frame.type='norm')
```

## Digging deeper into the clusters

The cluster-based customer introspection is also equally as easy:

```{r intro1}
transactions %>% 
  left_join(data_frame(customer_name=dat$customer_name, 
                       cluster=fit$cluster)) %>% 
  left_join(offers) -> customer_clusters

customer_clusters %>% 
  mutate(is_4=(cluster==4)) %>% 
  count(is_4, varietal) -> varietal_4
```
```{r nodo, eval=FALSE}
varietal_4
```
```{r intro_dt, echo=FALSE}
datatable(varietal_4, options=list(pageLength=nrow(varietal_4)))
```

```{r ismean}
customer_clusters %>% 
  mutate(is_4=(cluster==4)) %>% 
  group_by(is_4) %>% 
  summarise_each(funs(mean), min_qty, discount) -> mean_4
```
```{r nodo2, eval=FALSE}
mean_4
```
```{r mean_pan, echo=FALSE}
pander(mean_4)
```

## Fin

Remember to check out all the [things](http://blog.yhathq.com/posts/customer-segmentation-using-python.html) the&nbsp; $\hat{y}hat$ folks had to say about the analyses and the links they provided. 


