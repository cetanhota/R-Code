library(DBI)
library(RMySQL)
setwd("/home/wayne/R")
con <- dbConnect(MySQL(), user="", password="", 
                 dbname="", host="")
rq <- dbSendQuery(con, "SELECT * FROM 
                  raspberrypi.bmp order by id 
                  desc limit 288;")
BMP <- fetch(rq)
complete <- dbHasCompleted(rq)
dbClearResult(rq)
dbDisconnect(con)

BMP$ts <- as.POSIXct(BMP$ts, format="%H:%M:%S")

jpeg("BMP24HourReport.jpg")
plot(BMP$id, BMP$inhg, xlab="5 min collection", ylab="inhg", col="blue", 
     type="l",pch=16)
title(main="Barometric Pressure", sub="Last 24 Hours", col.main="blue")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted",
     lwd = par("lwd"), equilogs = TRUE)
dev.off()
