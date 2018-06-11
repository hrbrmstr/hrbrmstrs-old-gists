# Most of R, from an applied point of view anyway, is the process of creating objects and feeding them into functions to make amazing,  
# new objects. 

# amazing_new_object <- f(object)

  x <- c(3, 4, 5)
  y <- mean(x)

# This is true in the big picture sense as well
# information
# dataframe <- f(information)
# plot      <- f(dataframe)
# model     <- f(dataframe)
# table     <- f(model)
# report    <- f(plot, table)

# But before we get to that point...
# The first objects we typically work with can be described as data structures, and these can hold different types of data:

  typeof(1)      # double
  typeof("Yes")  # character
  typeof(FALSE)  # logical

# Types of data structures:

# Vectors - a one dimensional set of values that must all be of the same type. 
  c(1, 2, 3)      # All numbers
  c("Yes", "No")  # All characters
  c(FALSE, TRUE)  # All logical

# Matrices/Arrays - two or more dimensions

  m <- matrix(1:9, 3, 3)

  dim(m)

# Vectors, matrices, and arrays can only contain 1 kind of data. This is important to understand.

# What happens when we create a vector with multiple types of data?
  v <- c(1, TRUE, "Yes")
  typeof(v)
  v # You can see that the 1 and TRUE were converted to "1" and "TRUE"

# Lists are a special type of vector that allow us to combine different types of data. 

  v <- list(1, TRUE, "Yes")
  typeof(v[[1]]) # double
  typeof(v[[2]]) # logical
  typeof(v[[3]]) # character
  typeof(v)      # list

# Dataframes are in turn special types of lists that correspond to the concept of a dataset (a rectangular matirx of values, with 
# observations in rows and variables in columns, perhaps with some labels or other metadata attached)

  data <- data.frame(number = rnorm(50),
                     char   = sample(letters,        50, replace = TRUE),
                     logic  = sample(c(TRUE, FALSE), 50, replace = TRUE))

  View(data)

# There are cases where you want to "do something" to each element in a given data structure. For example, we might want to calcuate the 
# mean for each variable (column) in a dataframe. 

# Looping is a common way to do this. 

# Data

  library(tidyverse)

  data <- iris
  
  View(data)

# Print the mean for the first 4 columns of data

  for (i in 1:4){

    print(mean(data[[i]], na.rm = TRUE))

  }

# Or something slightly more complicated
# Create a new dataframe made up of the standardized values for first 4 columns of data. 

  results <- list() # Create a "blank" list

  for (i in 1:4){

    m  <- mean(data[[i]], na.rm = TRUE)
    sd <- sd(  data[[i]], na.rm = TRUE)

    results[[i]] <- (data[[i]] - m) / sd # Put results of the calcuation into the list

  }

  results <- do.call(cbind.data.frame, results) # Convert the list of results to a dataframe. 

# Plot the original data
  gather(data[, 1:4], var, value) %>%
  ggplot(aes(x = value, color = var, fill = var)) +
    geom_density() +
    facet_wrap(~var)

# Plot the standardized values
  gather(results, var, value) %>%
  ggplot(aes(x = value, color = var, fill = var)) +
    geom_density() +
    facet_wrap(~var)

# The argument against loops - Just google "Why shouldn't I use for loops r" for a deluge of reasons. 
# I use for loops all the time, and you probably will/should too, but the basic arguments against them are speed and clarity of code. 

# One of the strengths of R is vectorization. 
# For example, if I want to divide each value of a numeric vector by 2, I don't need a for loop that goes through each element of the 
# vector, doing the calcuation as I go. 

  v <- c()
  
  for(i in seq_along(data$Sepal.Length)){
    
    v[i] <- data$Sepal.Length[i] / 2
    
  }

  v

# I just do this:

  data$Sepal.Length / 2

# Apply functions are basically tools that take advatange of this vectorization to (sometimes) produce faster calcuations. 
# They are also usually more consise to write. As the name suggests, they apply a function to each element of an object. 

# The trick to apply functions is to know which type of object goes in and what comes out.

  ?apply

  m <- matrix(1:9, 3, 3)
  m
  apply(m, 2, mean)
  apply(m, 1, mean)

  apply(data[1:4], 2, mean) # Ok this works

  apply(data, 2, class) # The result here doesn't make sense. What happened?

# Apply works on arrays/matrices, which must all contain the same kind of data. The dataframe however includes a mixture of double and 
# character data types. So apply converted your dataframe into a character matrix, so the class for each column is also character. 

# For for dataframes, which are a special kind of list, we use lapply ("l"apply = list apply). 
  x <- lapply(data, class)
  x
  class(x)
  table(x) # The output of lapply is also a list, so using a function like table on it won't give good results. 

# So instead you can use sapply. It's just like lappy, but it "simplifies" the output. 
  x <- sapply(data, class)
  x
  class(x)
  table(x)

# I often use sapply to identify columns in a dataframe based on some characteristcs of the data. 

# One way to subset a dataframe by columns is to index with a logical vector, where you keep the columns i that correspond to i = TRUE 
# in a logical vector. 

# For example, if I want the first 4 columns, but not the fifth, I could do this: 

  data[c(TRUE, TRUE, TRUE, TRUE, FALSE)] %>% View()

# That's obviously very tedious. This is better:
  sapply(data, is.numeric)
  data[sapply(data, is.numeric)] %>% View()

# You can also set up conditional statements resulting in a logcal vector like this:

  data[sapply(data, class) == "numeric"]

# Exercise: Take the following dataframe, and consisely convert the c(1, 2) variables to a factor with the labels 1 = "No" and 2 = 
# "Yes".

# It has 1000 variables, and those with data = c(1, 2) are randomly scattered throughout. 
  fake <- list()
  
  for(i in 1:1000){
    flip <- sample(c(1:4), 1)
    
    if(flip == 1){fake[[i]] <- rnorm(                 50)}
    if(flip == 2){fake[[i]] <- sample(c(1, 2),        50, replace = TRUE)} # Convert these to factors later
    if(flip == 3){fake[[i]] <- sample(letters,        50, replace = TRUE)}
    if(flip == 4){fake[[i]] <- sample(c(TRUE, FALSE), 50, replace = TRUE)}
    
  }
  
  data <- do.call(cbind.data.frame, fake)

  names(data) <- paste0("V", c(1:length(data)))
  
# Here are the columns with min = 1, max = 2 and number of reponses = 2  
  data[sapply(data, function(x) min(as.numeric(x))) == 1 &
       sapply(data, function(x) max(as.numeric(x))) == 2 &
       sapply(data, function(x) length(table(as.numeric(x)))) == 2] 
  
# How did this work? Break it down. 
  sapply(data, function(x) min(as.numeric(x))) 
  sapply(data, function(x) min(as.numeric(x))) == 1 
  
  sapply(data, function(x) max(as.numeric(x))) 
  sapply(data, function(x) max(as.numeric(x))) == 2 
  
  sapply(data, function(x) length(table(as.numeric(x)))) 
  sapply(data, function(x) length(table(as.numeric(x)))) == 2
  
# Now replace those data with the factors
  
# Create the logical vector    
  these <- sapply(data, function(x) min(as.numeric(x))) == 1 &
           sapply(data, function(x) max(as.numeric(x))) == 2 &
           sapply(data, function(x) length(table(as.numeric(x)))) == 2

# Use lapply to turn those into factors             
  data[these] <- lapply(data[these], 
                        factor, 
                        levels = c(1, 2), labels = c("No", "Yes"))
  
  View(data)


