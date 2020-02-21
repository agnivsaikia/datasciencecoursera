library("data.table")

setwd("D:/Coursera_R/Exploratory_Project1/Exploratory_Project1")

power <- data.table::fread(input = "household_power_consumption.txt"
                             , na.strings="?"
)

power[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

power[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

power <- power[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

png("Plot_2.png", width=1080, height=1080)

plot(x = power[, dateTime]
     , y = power[, Global_active_power]
     , type="l", xlab="", ylab="Global Active Power (kilowatts)")

dev.off()