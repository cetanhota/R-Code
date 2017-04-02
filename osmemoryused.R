source("/Users/wayne/R/common_code/MySQL-buster-con.R")
library(bitops)
library(RCurl)
library(jsonlite)

setwd("/Users/wayne/R")
rces <- getURL("http://192.168.1.30:9200/logstash*/_search?q=type:OSMEMORYUSE&size=144&pretty=true")
esfj <- fromJSON(rces, simplifyVector = TRUE)
osmemorydf <- esfj$hits$hits$`_source`

#remove root user tasks
#osmemorydf <- osmemorydf[!grepl("root",osmemorydf$os_userid),]

#convert the timestamp
ts <- as.POSIXct(strptime(osmemorydf$os_timestamp, "%m-%d-%Y %H:%M:%S"))

#pull out only rows of data I want.
hostname <- osmemorydf[,grepl("host",names(osmemorydf))]
os_mem_used <- osmemorydf[,grepl("os_mem_used",names(osmemorydf))]
os_mem_free <- osmemorydf[,grepl("os_mem_free",names(osmemorydf))]

os_mem_used <- os_mem_used/1024
os_mem_free <- os_mem_free/1024

#create more custom data frame.
wwldf <- data.frame(ts,os_mem_used,os_mem_free, hostname)

#sort on ts
wwldf <- wwldf[order(ts),]

#write to csv file.
write.table(wwldf, "osmemoryused.csv", sep=",", row.names=FALSE)

#load csv file into mysql
wwltruncate <- dbSendQuery (con,"truncate table osmemoryused;")
wwlquery <- dbSendQuery (con, "LOAD DATA local INFILE '/Users/wayne/R/osmemoryused.csv'
                         INTO TABLE osmemoryused
                         FIELDS TERMINATED BY ','
                         ENCLOSED BY '\"'
                         IGNORE 1 LINES
                         (ts,os_mem_free,os_mem_used,hostname);")

dbClearResult(wwltruncate)
dbClearResult(wwlquery)
dbDisconnect(con)

plot(wwldf$ts, wwldf$os_mem_free, type="l", col="red", xlab="date", ylab="Used/Free", ylim=c(500,3500))
lines(wwldf$ts, wwldf$os_mem_used, col="blue", type="l", ylim=c(500,600))
title(main=paste("Memory Usage"), sub=, col.main="black")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "solid", lwd = par("lwd"), equilogs = TRUE)
legend("topleft", legend=c("Mem Free", "Mem Used"),col=c("Red", "Blue"), lty=1:1, cex=0.6, bg='white')
