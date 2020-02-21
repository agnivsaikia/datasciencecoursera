library("data.table")

setwd("D:/Coursera_R/Exploratory_Project1/Exploratory_Project1")

power <- data.table::fread(input = "household_power_consumption.txt"
                             , na.strings="?"
)

power[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

power[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

power <- power[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

png("Plot_3.png", width=1080, height=1080)

plot(power[, dateTime], power[, Sub_metering_1], type="l", xlab="", ylab="Energy sub metering", col="blue")
lines(power[, dateTime], power[, Sub_metering_2],col="green")
lines(power[, dateTime], power[, Sub_metering_3],col="red")
legend("topright"
       , col=c("blue","green","red")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       ,lty=c(1,1), lwd=c(1,1))

dev.off()