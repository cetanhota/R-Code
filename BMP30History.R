library(DBI)
library(RMySQL)
library(jsonlite)

id = fromJSON("/Users/wayne/R/common_code/keys.json")$id
pw = fromJSON("/Users/wayne/R/common_code/keys.json")$pw

setwd("/Users/wayne/R")
con <- dbConnect(MySQL(), user=(id), password=(pw), 
                 dbname="raspberrypi", host="192.168.1.21")
rq <- dbSendQuery(con, "SELECT dt,mxbmp FROM 
                  raspberrypi.history_bmp order by dt 
                  desc limit 30;")
BMP <- fetch(rq)
complete <- dbHasCompleted(rq)
dbClearResult(rq)
dbDisconnect(con)
BMP$dt <- as.Date(BMP$dt) # format="%m-%d-%y"
#jpeg("HighBMPGraph.jpg")
plot(BMP$dt, BMP$mxbmp, xlab="Date", ylab="inHg", col="green", 
     type="l",pch=16)
title(main="Barometric Pressure", sub="Last 30 days", col.main="purple")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "solid",
     lwd = par("lwd"), equilogs = TRUE)
#dev.off()
