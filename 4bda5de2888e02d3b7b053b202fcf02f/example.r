test_df <- list(
  list(
    list(
      iris[sample(1:150,3),],
      iris[sample(1:150,3),]
    ),
    list(
      list(
        iris[sample(1:150,3),],
        list(
          iris[sample(1:150,3),],
          iris[sample(1:150,3),]
        )
      )
    )
  )
)

str(flatten_dfs(test_df))
## List of 5
##  $ :'data.frame': 3 obs. of  5 variables:
##   ..$ Sepal.Length: num [1:3] 6.1 6.2 6.3
##   ..$ Sepal.Width : num [1:3] 2.9 2.8 2.5
##   ..$ Petal.Length: num [1:3] 4.7 4.8 5
##   ..$ Petal.Width : num [1:3] 1.4 1.8 1.9
##   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 2 3 3
##  $ :'data.frame': 3 obs. of  5 variables:
##   ..$ Sepal.Length: num [1:3] 5.5 6.4 6.4
##   ..$ Sepal.Width : num [1:3] 2.4 2.7 2.8
##   ..$ Petal.Length: num [1:3] 3.7 5.3 5.6
##   ..$ Petal.Width : num [1:3] 1 1.9 2.2
##   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 2 3 3
##  $ :'data.frame': 3 obs. of  5 variables:
##   ..$ Sepal.Length: num [1:3] 4.8 5.5 4.5
##   ..$ Sepal.Width : num [1:3] 3 2.4 2.3
##   ..$ Petal.Length: num [1:3] 1.4 3.8 1.3
##   ..$ Petal.Width : num [1:3] 0.1 1.1 0.3
##   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 2 1
##  $ :'data.frame': 3 obs. of  5 variables:
##   ..$ Sepal.Length: num [1:3] 5.5 5.2 6.5
##   ..$ Sepal.Width : num [1:3] 2.4 3.5 3
##   ..$ Petal.Length: num [1:3] 3.8 1.5 5.5
##   ..$ Petal.Width : num [1:3] 1.1 0.2 1.8
##   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 2 1 3
##  $ :'data.frame': 3 obs. of  5 variables:
##   ..$ Sepal.Length: num [1:3] 6.7 6.9 6.9
##   ..$ Sepal.Width : num [1:3] 3 3.1 3.1
##   ..$ Petal.Length: num [1:3] 5 5.1 5.4
##   ..$ Petal.Width : num [1:3] 1.7 2.3 2.1
##   ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 2 3 3