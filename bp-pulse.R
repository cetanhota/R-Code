library(DBI)
library(RMySQL)
library(jsonlite)
library(gridExtra)

source("/Users/wayne/R/common_code/common_code_V1.R")

con <- bp_db_connect()
wwlquery <- dbSendQuery (con, "select ts,systolic,diastolic, pulse,comments 
 from bp where ts >='2017-06-01 00:00:00' and ts <='2017-07-01 00:00:00'
                    order by ts desc;")

wwldf <- fetch(wwlquery)
complete <- dbHasCompleted(wwlquery)
dbClearResult(wwlquery)
dbDisconnect(con)

#write to csv file.
filepath <- getfilepath()
wwldfcsv <- wwldf[order(wwldf$ts),]
write.table(wwldfcsv, paste0(filepath, "/BP/June2017.csv"), sep=",", row.names=FALSE)
rm (wwldfcsv)

ts <- as.POSIXct(strptime(wwldf$ts, "%Y-%m-%d %H:%M:%S"))
wwldf$date <- as.Date(wwldf$ts)
wwldf$date <- as.character(wwldf$date, "%m/%d/%Y")

plot(ts, wwldf$systolic,type="l", col="red", xlab="Date:", ylab="Systolic/Diastolic", ylim=c(50,175))
lines(ts,wwldf$diastolic, col="blue", type="l")
title(main=paste("Blood Pressure"), sub=paste(wwldf$date [1]), col.main="black")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "solid", lwd = par("lwd"), equilogs = TRUE)
legend("topleft", legend=c("Systolic", "Diastolic"),col=c("Red", "Blue"), lty=1:1, cex=0.6, bg='white')

dev.copy2pdf(file = paste0(filepath, '/BP/BpJune2017.pdf'))

plot(ts, wwldf$pulse,type="l", col="green", xlab="Date:", ylab="PRbpm")
title(main=paste("Pulse"), sub=paste(wwldf$date [1]), col.main="black")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "solid", lwd = par("lwd"), equilogs = TRUE)

dev.copy2pdf(file = paste0(filepath, '/BP/PulseJune2017.pdf'))

summ <- data.frame(wwldf$systolic,wwldf$diastolic,wwldf$pulse)
summary(summ)
