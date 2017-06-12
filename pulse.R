source("/Users/wayne/R/common_code/MySQL-bp-con.R")
setwd("/Users/wayne/R")

con <- dbConnect(MySQL(), user=(id), password=(pw), 
                 dbname="bloodpressure", host="192.168.1.21")
wwlquery <- dbSendQuery(con, "select pulse, ts from bp where ts like '2017-03-08%'
                        order by ts desc;")

#(con, "select pulse,ts from bp order by ts desc limit 4")

wwldf <- fetch(wwlquery)
complete <- dbHasCompleted(wwlquery)
dbClearResult(wwlquery)
dbDisconnect(con)

ts <- as.POSIXct(strptime(wwldf$ts, "%Y-%m-%d %H:%M:%S"))
#jpeg("pulse.jpg")
plot(ts, wwldf$pulse,type="l", col="red", xlab="Date/Time", ylab="Pulse", ylim=c(0,120))
title(main=paste("Pulse"), sub=paste(""), col.main="Purple")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = TRUE)
#dev.off()