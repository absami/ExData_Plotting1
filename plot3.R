# Please set your working directory here to include the location where household_power_consumption.txt
# is located. The resulting plots will also be generated at the same location.
setwd("~")

library("sqldf")  # To subset the data frame while reading it.
library("dplyr")  
library("lubridate")  # For working with dates

# Check if the program is able to find the data file.
if (!file.exists("household_power_consumption.txt")) {
    stop("Could not find file \"household_power_consumption.txt\" in your working directory
  Please set your working directory to include the location where \"household_power_consumption.txt\" is located.")
}

# Read in the data
data <- read.csv.sql("household_power_consumption.txt", stringsAsFactors = FALSE, header = TRUE, sep = ";", 
                     row.names = FALSE, sql = "select * from file where Date in ('1/2/2007','2/2/2007')")

par(mfrow = c(1,1))  #reset the graphic device
par(mar = c(5, 5, 2, 2))  #select some better margins

# Add a new column containing a date and time concatenated together. Then convert them to date-time stamp.
# Otherwise you cannot get name of days on the x axis with an easy method. That is if you try to simply use
# date by converting it using as.Date, it will convert it to a factor and hence instead of a normal plot, you get a box plot.
data <- mutate(data, new = paste(Date, Time))
data <- cbind(data, datetime = strptime(data[, "new"],format = "%d/%m/%Y %H:%M:%S"))  # mutate does not support posixlt format..

# Remove the 'new' data column
data <- select(data, -new)


# Plot the third graph
with(data, plot(datetime, as.numeric(as.character(Sub_metering_1)), type="l", col = "black", xlab=NA, ylab="Energy Sub metering"))
with(data, lines(datetime, as.numeric(as.character(Sub_metering_2)), type="l", col = "red"))
with(data, lines(datetime, as.numeric(as.character(Sub_metering_3)), type="l", col = "blue"))
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1,1,1), lwd=c(2.5,2.5, 2.5),col=c("black", "red", "blue"))

dev.copy(png, "plot3.png", width=480, height=480)
dev.off()