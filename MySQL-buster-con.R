library(DBI)
library(RMySQL)
library(jsonlite)

id = fromJSON("/Users/wayne/R/common_code/keys.json")$id
pw = fromJSON("/Users/wayne/R/common_code/keys.json")$pw

con <- dbConnect(MySQL(), user=(id), password=(pw), 
                 dbname="buster", host="192.168.1.21")