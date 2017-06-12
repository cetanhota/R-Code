source("/Users/wayne/R/common_code/normalize_fn.R")
setwd("/Users/wayne/R")

library(ggvis)
library(class)
library(gmodels)
iris <- iris

# Concatenate names(), c() Combine Values into a Vector or List
names(iris) <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species")

#iris %>% ggvis(~Sepal.Length, ~Sepal.Width, fill = ~Species) %>% layer_points()
#iris %>% ggvis(~Petal.Length, ~Petal.Width, fill = ~Species) %>% layer_points()


#summary function and combine values
#summary(iris[c("Petal.Width", "Sepal.Width")])

#summary function
summary(iris)

#Normalize data in iris, column 1 - 4
iris_norm <- as.data.frame(lapply(iris[1:4], normalize))
summary(iris_norm)

set.seed(1234)
ind <- sample(2, nrow(iris), replace=TRUE, prob=c(0.67, 0.33))
iris.training <- iris[ind==1, 1:4]
iris.test <- iris[ind==2, 1:4]
iris.trainLabels <- iris[ind==1, 5]
iris.testLabels <- iris[ind==2, 5]
iris_pred <- knn(train = iris.training, test = iris.test, cl = iris.trainLabels, k=3)
iris_pred
CrossTable(x = iris.testLabels, y = iris_pred, prop.chisq=FALSE)
