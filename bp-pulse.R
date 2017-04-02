source("/Users/wayne/R/common_code/MySQL-bp-con.R")
setwd("/Users/wayne/R")
library(gridExtra)

wwlquery <- dbSendQuery (con, "select ts,systolic,diastolic, pulse,comments 
 from bp where ts >='2017-04-01 00:00:00' and ts <='2017-04-07 00:00:00'
                    order by ts desc;")

wwldf <- fetch(wwlquery)
complete <- dbHasCompleted(wwlquery)
dbClearResult(wwlquery)
dbDisconnect(con)

#write to csv file.
wwldfcsv <- wwldf[order(wwldf$ts),]
write.table(wwldfcsv, "/Users/wayne/R/BP/April2017.csv", sep=",", row.names=FALSE)
rm (wwldfcsv)

#order on TS and export to PDF
#wwldfpdf <- wwldf[order(wwldf$ts),]
#pdf("March2017-%03d.pdf",height = 11,width = 8.5)
#grid.table(wwldfpdf, rows=NULL)
#dev.off()
#rm (wwldfpdf)

ts <- as.POSIXct(strptime(wwldf$ts, "%Y-%m-%d %H:%M:%S"))
wwldf$date <- as.Date(wwldf$ts)
wwldf$date <- as.character(wwldf$date, "%m/%d/%Y")

#jpeg("BpMarch2017.jpg")

plot(ts, wwldf$systolic,type="l", col="red", xlab="Date:", ylab="Systolic/Diastolic", ylim=c(50,175))
lines(ts,wwldf$diastolic, col="blue", type="l")
title(main=paste("Blood Pressure"), sub=paste(wwldf$date [1]), col.main="black")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "solid", lwd = par("lwd"), equilogs = TRUE)
legend("topleft", legend=c("Systolic", "Diastolic"),col=c("Red", "Blue"), lty=1:1, cex=0.6, bg='white')

dev.copy2pdf(file = '/Users/wayne/R/BP/BpApril2017.pdf')
#jpeg("PulseMarch2017.jpg")

plot(ts, wwldf$pulse,type="l", col="green", xlab="Date:", ylab="PRbpm")
title(main=paste("Pulse"), sub=paste(wwldf$date [1]), col.main="black")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "solid", lwd = par("lwd"), equilogs = TRUE)

dev.copy2pdf(file = '/Users/wayne/R/BP/PulseApril2017.pdf')
