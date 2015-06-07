# Please set your working directory here to include the location where household_power_consumption.txt
# is located. The resulting plots will also be generated at the same location.
setwd("~")

library("sqldf")  # To subset the data frame while reading it.
library("lubridate")  # For working with dates

# Check if the program is able to find the data file.
if (!file.exists("household_power_consumption.txt")) {
    stop("Could not find file \"household_power_consumption.txt\" in your working directory
  Please set your working directory to include the location where \"household_power_consumption.txt\" is located.")
}

# Read in the data
data <- read.csv.sql("household_power_consumption.txt", stringsAsFactors = FALSE, header = TRUE, sep = ";", 
                    row.names = FALSE, sql = "select * from file where Date in ('1/2/2007','2/2/2007')")
#datadf <- tbl_df(data)
par(mfrow = c(1,1))  #reset the graphic device
par(mar = c(5, 5, 2, 2))  #select some better margins

# Plot the first graph
with(data, hist(as.numeric(as.character(Global_active_power)), col = "red", xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency", main = "Global Active Power"))

# Save the plot to a png file
dev.copy(png, "plot1.png", width=480, height=480)  # 480x480 is the default size anyway
dev.off()