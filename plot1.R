rm(list=ls(all=TRUE))
setwd("~/Desktop/coursera4-exploratory-data/assignment_1/")

library("sqldf")  # To subset the data frame while reading it.
library("dplyr")
library("lubridate")

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