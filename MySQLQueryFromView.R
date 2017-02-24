library(DBI)
library(RMySQL)
setwd("/home/wayne/R")
con <- dbConnect(MySQL(), user="", password="", 
                 dbname="raspberrypi", host="192.168.1.21")
rq <- dbSendQuery(con, "SELECT date,high,low FROM 
                  raspberrypi.v_history order by date 
                  desc limit 30;")
DHT <- fetch(rq)
complete <- dbHasCompleted(rq)
dbClearResult(rq)
dbDisconnect(con)
DHT$Date <- as.Date(DHT$Date) # format="%m-%d-%y"
jpeg("HighTempGraph.jpg")
plot(DHT$Date, DHT$High, xlab="Date", ylab="High", col="red", 
     type="b",pch=16)
title(main="High Temperatures", sub="Last 30 days", col.main="red")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = TRUE)
dev.off()
jpeg("LowTempGraph.jpg")
plot(DHT$Date, DHT$Low, xlab="Date", ylab="Low", col="blue",
     type="b", pch=16)
title(main="Low Temperatures", sub="Last 30 days", col.main="blue")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = TRUE)
dev.off()
