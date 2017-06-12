library(DBI)
library(RMySQL)
library(jsonlite)

id = fromJSON("/home/wayne/R/common_code/keys.json")$id
pw = fromJSON("/home/wayne/R/common_code/keys.json")$pw

con <- dbConnect(MySQL(), user=(id), password=(pw), 
                 dbname="bloodpressure", host="192.168.1.21")