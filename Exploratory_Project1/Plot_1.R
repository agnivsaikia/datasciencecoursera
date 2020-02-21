library("data.table")

setwd("D:/Coursera_R/Exploratory_Project1/Exploratory_Project1")


power <- data.table::fread(input = "household_power_consumption.txt"
                             , na.strings="?"
)

power[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

power[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

power <- power[(Date >= "2007-02-01") & (Date <= "2007-02-02")]

png("Plot_1.png", width=1080, height=1080)

hist(power[, Global_active_power], main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Green")

dev.off()