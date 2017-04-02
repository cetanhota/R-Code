library(curl)
library(jsonlite)

setwd("/Users/wayne/R")

#pull down the data from ES to a local json file.
curl_download("http://192.168.1.30:9200/logstash*/_search?q=type:OSTOP5CPU&size=72&pretty=true", "ostop5cpu.json")

#read the json file create temp data frame to hold data.
json_file <- fromJSON("ostop5cpu.json")
tempdf <- as.data.frame(json_file)

#pull the data out of the temp data frame to create the needed data frame.
ostaskdf <- as.data.frame(tempdf$hits.hits._source)

#remove root user tasks
ostaskdf <- ostaskdf[!grepl("root",ostaskdf$os_userid),]

#remove the temp data frame.
rm (tempdf)

#convert the timestamp
ts <- as.POSIXct(strptime(ostaskdf$os_timestamp, "%m-%d-%Y %H:%M:%S"))

#pull out only rows of data I want.
hostname <- ostaskdf[ , grepl( "host", names( ostaskdf ) ) ]
os_task <- ostaskdf[ , grepl( "os_task", names( ostaskdf ) ) ]
os_cpupctused <- ostaskdf[ , grepl( "os_cpupctused", names( ostaskdf ) ) ]
os_userid <- ostaskdf[ , grepl( "os_userid", names( ostaskdf ) ) ]

#create more custom data frame.
wwldf <- data.frame(ts,os_userid,os_task,os_cpupctused,hostname)

#sort on ts
wwldf <- wwldf[order(ts),]

counts <- table(wwldf$os_cpupctused)

plot(wwldf$ts, wwldf$os_cpupctused, type="l", col="red", xlab="", ylab="CPU % Used")
barplot(wwldf$os_cpupctused, ylab="CPU % Used")
