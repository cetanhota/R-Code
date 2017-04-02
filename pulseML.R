source("/Users/wayne/R/common_code/MySQL-bp-con.R")
setwd("/Users/wayne/R")
library(ggvis)

wwlquery <- dbSendQuery (con, "select systolic,diastolic,pulse 
                         from bp where ts >='2017-03-05 00:00:00' and ts <='2017-03-12 00:00:00'
                         order by ts desc;")

wwlpulsedf <- fetch(wwlquery)
complete <- dbHasCompleted(wwlquery)
dbClearResult(wwlquery)
dbDisconnect(con)

wwlpulsedf %>% ggvis(~systolic, ~diastolic, fill = ~pulse) %>% layer_points()