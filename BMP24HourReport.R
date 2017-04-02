library(DBI)
library(RMySQL)
library(jsonlite)

id = fromJSON("/home/wayne/R/common_code/keys.json")$id
pw = fromJSON("/home/wayne/R/common_code/keys.json")$pw

setwd("/home/wayne/R")
con <- dbConnect(MySQL(), user=(id), password=(pw), 
                 dbname="raspberrypi", host="192.168.1.21")
rq <- dbSendQuery(con, "SELECT * FROM 
                  raspberrypi.bmp order by id 
                  desc limit 288;")
BMP <- fetch(rq)
complete <- dbHasCompleted(rq)
dbClearResult(rq)
dbDisconnect(con)
ts <- as.POSIXct(strptime(BMP$ts, "%Y-%m-%d %H:%M:%S"))

jpeg("BMP24HourReport.jpg")
plot(ts, BMP$inhg, xlab="5 min collection", ylab="inhg", col="blue", 
     type="l",pch=16)
title(main="Barometric Pressure", sub="Last 24 Hours", col.main="blue")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted",
     lwd = par("lwd"), equilogs = TRUE)
dev.off()