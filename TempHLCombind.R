library(DBI)
library(RMySQL)
library(jsonlite)

id <-  fromJSON("/Users/wayne/R/common_code/keys.json")$id
pw <-  fromJSON("/Users/wayne/R/common_code/keys.json")$pw

setwd("/Users/wayne/R")
con <- dbConnect(MySQL(), user=(id), password=(pw), 
                 dbname="raspberrypi", host="192.168.1.21")
rq <- dbSendQuery(con, "SELECT date,high,low FROM 
                  raspberrypi.v_history order by date 
                  desc limit 30;")
DHT <- fetch(rq)
complete <- dbHasCompleted(rq)
dbClearResult(rq)
dbDisconnect(con)
DHT$Date <- as.Date(DHT$Date) # format="%m-%d-%y"

hightmp <- data.frame(DHT$High)
avghightmp <- colSums(hightmp/30)
avghightmp <- round(avghightmp,2)

#jpeg("TempHLGraph.jpg")

plot(DHT$Date, DHT$High,type="l", col="red", xlab="Date", ylab="High/Low", ylim=c(0,100))
lines(DHT$Date,DHT$Low, col="blue", type="l")

title(main=paste("WeatherPi 30 Day Report"), sub=paste("Avg Temp:", avghightmp,"F"), col.main="Purple")
legend("topleft", legend=c("High", "Low"),col=c("Red", "Blue"), lty=1:1, cex=0.8)
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = TRUE)

#dev.off()

summary(DHT)
summary(DHT[c("High", "Low")])
