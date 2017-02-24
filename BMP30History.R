library(DBI)
library(RMySQL)
setwd("/home/wayne/R")
con <- dbConnect(MySQL(), user="", password="", 
                 dbname="raspberrypi", host="192.168.1.21")
rq <- dbSendQuery(con, "SELECT dt,mxbmp FROM 
                  raspberrypi.history_bmp order by dt 
                  desc limit 30;")
BMP <- fetch(rq)
complete <- dbHasCompleted(rq)
dbClearResult(rq)
dbDisconnect(con)
BMP$dt <- as.Date(BMP$dt) # format="%m-%d-%y"
jpeg("HighBMPGraph.jpg")
plot(BMP$dt, BMP$mxbmp, xlab="Date", ylab="inHg", col="blue", 
     type="b",pch=16)
title(main="Barometric Pressure", sub="Last 30 days", col.main="blue")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted",
     lwd = par("lwd"), equilogs = TRUE)
dev.off()
