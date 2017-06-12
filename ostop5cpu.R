source("/Users/wayne/R/common_code/MySQL-buster-con.R")
library(bitops)
library(RCurl)
library(jsonlite)

setwd("/Users/wayne/R")
rces <- getURL("http://192.168.1.30:9200/logstash*/_search?q=type:OSTOP5CPU&size=144&pretty=true")
esfj <- fromJSON(rces, simplifyVector = TRUE)
ostaskdf <- esfj$hits$hits$`_source`

#remove root user tasks
ostaskdf <- ostaskdf[!grepl("root",ostaskdf$os_userid),]

#convert the timestamp
ts <- as.POSIXct(strptime(ostaskdf$os_timestamp, "%m-%d-%Y %H:%M:%S"))

#pull out only rows of data I want.
hostname <- ostaskdf[,grepl("host",names(ostaskdf))]
os_task <- ostaskdf[,grepl("os_task",names(ostaskdf))]
os_cpupctused <- ostaskdf[,grepl("os_cpupctused",names(ostaskdf))]
os_userid <- ostaskdf[,grepl("os_userid",names(ostaskdf))]

#create more custom data frame.
wwldf <- data.frame(ts,os_userid,os_task,os_cpupctused,hostname)

#sort on ts
wwldf <- wwldf[order(ts),]

#write to csv file.
write.table(wwldf, "ostop5cpu.csv", sep=",", row.names=FALSE)

#load csv file into mysql
wwltruncate <- dbSendQuery (con,"truncate table ostop5cpu;")
wwlquery <- dbSendQuery (con, "LOAD DATA local INFILE '/Users/wayne/R/ostop5cpu.csv'
                         INTO TABLE ostop5cpu
                         FIELDS TERMINATED BY ','
                         ENCLOSED BY '\"'
                         IGNORE 1 LINES
                         (ts,os_userid,os_task,os_cpupctused,hostname);")

dbClearResult(wwltruncate)
dbClearResult(wwlquery)
dbDisconnect(con)

plot(wwldf$ts, wwldf$os_cpupctused, type="l", col="blue", xlab="server: rose-lab1", ylab="CPU % Used")
title(main="mysqladm, cpu usage", sub="", col.main="black")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "solid", lwd = par("lwd"), equilogs = TRUE)

