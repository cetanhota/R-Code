library(DBI)
library(RMySQL)
setwd("/Users/wayne/R")
con <- dbConnect(MySQL(), user="", password="", 
                 dbname="raspberrypi", host="192.168.1.21")
rq <- dbSendQuery(con, "SELECT date,high,low FROM 
                  raspberrypi.v_history order by date 
                  desc limit 60;")
DHT <- fetch(rq)
complete <- dbHasCompleted(rq)
dbClearResult(rq)
dbDisconnect(con)
DHT$Date <- as.Date(DHT$Date) # format="%m-%d-%y"
#jpeg("TempGraph.jpg")
plot(DHT$Date, DHT$High,type="l", col="red", xlab="Date", ylab="High/Low", ylim=c(0,100))
title(main="Temperatures", sub="Last 30 days", col.main="black")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = TRUE)
lines(DHT$Date,DHT$Low, col="blue", type="l")
legend("topleft", legend=c("High", "Low"),col=c("Red", "Blue"), lty=1:1, cex=0.8)
#dev.off()
