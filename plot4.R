rm(list=ls(all=TRUE))
setwd("~/Desktop/coursera4-exploratory-data/assignment_1/")

library("sqldf")  # To subset the data frame while reading it.
library("dplyr")
library("lubridate")

data <- read.csv.sql("household_power_consumption.txt", stringsAsFactors = FALSE, header = TRUE, sep = ";", 
                     row.names = FALSE, sql = "select * from file where Date in ('1/2/2007','2/2/2007')")

# Plot the first graph
with(data, hist(as.numeric(as.character(Global_active_power)), col = "red", xlab = "Global Active Power (kilowatts)", 
                ylab = "Frequency", main = "Global Active Power"))


# Add a new column containing a date and time concatenated together. Then convert them to date-time stamp.
# Otherwise you cannot get name of days on the x axis with an easy method. That is if you try to simply use
# date by converting it using as.Date, it will convert it to a factor and hence instead of a normal plot, you get a box plot.
data <- mutate(data, new = paste(Date, Time))
data <- cbind(data, datetime = strptime(data[, "new"],format = "%d/%m/%Y %H:%M:%S"))  # mutate does not support posixlt format..

# Remove the 'new' data column
data <- select(data, -new)

# Plot the second graph
with(data, plot(datetime, as.numeric(as.character(Global_active_power)), type="l", 
                xlab = NA, ylab="Global Active Power (kilowatts)"))

# Plot all graphs in a 2x2 subplot
par(mfrow=c(2,2))
par(mar = c(5, 5, 2, 2))  #select some better margins

with(data, plot(datetime, as.numeric(as.character(Global_active_power)), type="l", 
                xlab = NA, ylab="Global Active Power (kilowatts)"))
with(data, plot(datetime, as.numeric(as.character(Voltage)), type="l", col = "black", xlab="datetime", ylab="Voltage"))

with(data, plot(datetime, as.numeric(as.character(Sub_metering_1)), type="l", col = "black", xlab=NA, ylab="Energy Sub metering"))
with(data, lines(datetime, as.numeric(as.character(Sub_metering_2)), type="l", col = "red"))
with(data, lines(datetime, as.numeric(as.character(Sub_metering_3)), type="l", col = "blue"))
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1,1,1), lwd=c(2.5,2.5, 2.5),col=c("black", "red", "blue"))

with(data, plot(datetime, as.numeric(as.character(Global_reactive_power)), type="l", col = "black", xlab="datetime", ylab="Global_reactive_power"))

dev.copy(png, "plot4.png", width=480, height=480)
dev.off()