source("/Users/wayne/R/common_code/MySQL-buster-con.R")
library(bitops)
library(RCurl)
library(jsonlite)

setwd("/Users/wayne/R")
rces <- getURL("http://192.168.1.30:9200/logstash*/_search?q=type:OSSWAPUSE&size=144&pretty=true")
esfj <- fromJSON(rces, simplifyVector = TRUE)
swapusedf <- esfj$hits$hits$`_source`

#convert the timestamp
ts <- as.POSIXct(strptime(swapusedf$os_timestamp, "%m-%d-%Y %H:%M:%S"))

#pull out only rows of data I want.
hostname <- swapusedf[,grepl("host",names(swapusedf))]
os_swap_total <- swapusedf[,grepl("os_swap_total",names(swapusedf))]
os_swap_used <- swapusedf[,grepl("os_swap_used",names(swapusedf))]
os_swap_free <- swapusedf[,grepl("os_swap_free",names(swapusedf))]

os_swap_total <- os_swap_total/1024
os_swap_used <- os_swap_used/1024
os_swap_free <- os_swap_free/1024

#create more custom data frame.
wwldf <- data.frame(ts,os_swap_total,os_swap_used,os_swap_free, hostname)

#sort on ts
wwldf <- wwldf[order(ts),]

#write to csv file.
write.table(wwldf, "osswapuse.csv", sep=",", row.names=FALSE)

#load csv file into mysql
wwltruncate <- dbSendQuery (con,"truncate table osswapuse;")
wwlquery <- dbSendQuery (con, "LOAD DATA local INFILE '/Users/wayne/R/osswapuse.csv'
                         INTO TABLE osswapuse
                         FIELDS TERMINATED BY ','
                         ENCLOSED BY '\"'
                         IGNORE 1 LINES
                         (ts,os_swap_total,os_swap_used,os_swap_free,hostname);")

dbClearResult(wwltruncate)
dbClearResult(wwlquery)
dbDisconnect(con)