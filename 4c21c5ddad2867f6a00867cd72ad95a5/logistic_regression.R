# Load the raw training data and replace missing values with NA
training.data.raw <- read.csv('train.csv',header=T,na.strings=c(""))

# Output the number of missing values for each column
sapply(training.data.raw,function(x) sum(is.na(x)))

# Quick check for how many different values for each feature
sapply(training.data.raw, function(x) length(unique(x)))

# A visual way to check for missing data
library(Amelia)
missmap(training.data.raw, main = "Missing values vs observed")

# Subsetting the data
data <- subset(training.data.raw,select=c(2,3,5,6,7,8,10,12))

# Substitute the missing values with the average value
data$Age[is.na(data$Age)] <- mean(data$Age,na.rm=T)

# R should automatically code Embarked as a factor(). A factor is R's way of dealing with
# categorical variables
is.factor(data$Sex)         # Returns TRUE
is.factor(data$Embarked)    # Returns TRUE

# Check categorical variables encoding for better understanding of the fitted model
contrasts(data$Sex)
contrasts(data$Embarked)

# Remove rows (Embarked) with NAs
data <- data[!is.na(data$Embarked),]
rownames(data) <- NULL

# Train test splitting
train <- data[1:800,]
test <- data[801:889,]

# Model fitting
model <- glm(Survived ~.,family=binomial(link='logit'),data=train)
summary(model)

# Analysis of deviance
anova(model,test="Chisq")

# McFadden R^2
library(pscl)
pR2(model)

#-------------------------------------------------------------------------------
# MEASURING THE PREDICTIVE ABILITY OF THE MODEL

# If prob > 0.5 then 1, else 0. Threshold can be set for better results
fitted.results <- predict(model,newdata=subset(test,select=c(2,3,4,5,6,7,8)),type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)

misClasificError <- mean(fitted.results != test$Survived)
print(paste('Accuracy',1-misClasificError))

# Confusion matrix
library(caret)
confusionMatrix(data=fitted.results, reference=test$Survived)

library(ROCR)
# ROC and AUC
p <- predict(model, newdata=subset(test,select=c(2,3,4,5,6,7,8)), type="response")
pr <- prediction(p, test$Survived)
# TPR = sensitivity, FPR=specificity
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc