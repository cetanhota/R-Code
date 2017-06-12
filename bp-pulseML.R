library(ggvis)
library(class)
library(gmodels)

source("/Users/wayne/R/common_code/common_code_V1.R")

#dont go back past 02/20/2017
con <- bp_db_connect()
wwlquery <- dbSendQuery (con, "select systolic,diastolic,stage 
                         from bp where ts >='2017-02-20 00:00:00' and ts <='2017-06-01 00:00:00'
                         order by ts desc;")
wwldf <- fetch(wwlquery)
complete <- dbHasCompleted(wwlquery)
dbClearResult(wwlquery)
dbDisconnect(con)

#wwldf <- read.csv("bp-raw.csv")
#sort on stage
wwldf <- wwldf[order(wwldf$stage),]

wwldf %>% ggvis(~systolic, ~diastolic, fill = ~stage) %>% layer_points()

wwldf_norm <- as.data.frame(lapply(wwldf[1:2], normalize))
summary(wwldf)
summary(wwldf_norm)

set.seed(1234)
ind <- sample(2, nrow(wwldf), replace=TRUE, prob=c(0.67, 0.33))
wwldf.training <- wwldf[ind==1, 1:2]
wwldf.test <- wwldf[ind==2, 1:2]
wwldf.trainLabels <- wwldf[ind==1, 3]
wwldf.testLabels <- wwldf[ind==2, 3]
wwldf_pred <- knn(train = wwldf.training, test = wwldf.test, cl = wwldf.trainLabels, k=3)
wwldf_pred
CrossTable(x = wwldf.testLabels, y = wwldf_pred, prop.chisq=FALSE)

