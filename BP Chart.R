library(DBI)
library(RMySQL)
con <- dbConnect(MySQL(), user="mysqladm", password="hawk69", 
                 dbname="bloodpressure", host="192.168.1.21")
syst <- dbSendQuery(con, "select systolic from bp order by ID desc limit 10;")
upperbp <- fetch(syst)
complete <- dbHasCompleted(syst)

dias <- dbSendQuery(con, "select diastolic from bp order by ID desc limit 10;")
lowerbp <- fetch(dias)
complete <- dbHasCompleted(dias)

#dfbp <- data.frame(lbp=lowerbp,ubp=upperbp)

dbClearResult(syst,dias)
dbDisconnect(con)

plot(upperbp$systolic, type="l", col="blue", ylim=c(0,200), ylab="Systolic/Diastolic")
grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted",
     lwd = par("lwd"), equilogs = TRUE)
lines(lowerbp$diastolic, col="purple")
# Add a legend
legend("topleft", legend=c("Systolic", "Diastolic"),
       col=c("blue", "purple"), lty=1:1, cex=0.8)
