# filenames for zipped and unzipped data
dataOutZip <- "household_power_consumption.zip"
dataOut <- "household_power_consumption.txt"

# download zip file if the zipped or unzipped data not in folder
if(!file.exists(dataOut) | !file.exists(dataOutZip)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, dataOutZip, method = "curl", mode = "wb")
}

# extract zip file if unzipped file not in folder
if(!file.exists(dataOut)){
  unzip(zipfile = dataOutZip, exdir = getwd())
}

# read data while setting the date/time column class to character and the data to numeric
colClass <- c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")
dt <- read.table(dataOut,sep = ";",colClasses = colClass,header=TRUE,na.strings = "?")

# open the dplyr library for data transformation
library(dplyr)
dt4 <- dt

# create new column for DateTime in POSIXlt format, set date to Date format
dt4$DateTime <- strptime(paste(dt4$Date,dt4$Time,sep = " "),format="%d/%m/%Y %H:%M:%S")
dt4$Date <- as.Date(dt4$Date,format="%d/%m/%Y")

# filter data frame on feb 1-2 2007
dat <- dt4 %>% filter(Date >= "2007-02-01" & Date <= "2007-02-02")

# create 4 line charts in a 2x2 matrix, with the x-axis as datetime
# topleft vs global active power, top right vs voltage
# bottom left vs submeters 1:3, bottom right global reactive power
par(mfrow = c(2,2))
with(dat, {
  plot(DateTime, Global_active_power, ylab = "Global Active Power",type="l", xlab = "")
  plot(DateTime, Voltage, xlab = "datetime", ylab = "Voltage",type="l")
  plot(DateTime, Sub_metering_1,col="black", xlab = "", ylab = "Energy sub metering",type="l")
  lines(DateTime, Sub_metering_2,col="red",type="l")
  lines(DateTime, Sub_metering_3,col="blue",type="l")
  legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lty = 1, bty = "n")
  plot(DateTime, Global_reactive_power,col="black", xlab = "datetime", ylab = "Global Reactive power",type="l")
})

# open the png library for writing to png
library(png)
# open png of size 480x480, written to plot4.png, and plot the same line chart as above
png(filename="plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))
with(dat, {
  plot(DateTime, Global_active_power, ylab = "Global Active Power",type="l", xlab = "")
  plot(DateTime, Voltage, xlab = "datetime", ylab = "Voltage",type="l")
  plot(DateTime, Sub_metering_1,col="black", xlab = "", ylab = "Energy sub metering",type="l")
  lines(DateTime, Sub_metering_2,col="red",type="l")
  lines(DateTime, Sub_metering_3,col="blue",type="l")
  legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lty = 1, bty = "n")
  plot(DateTime, Global_reactive_power,col="black", xlab = "datetime", ylab = "Global Reactive power",type="l")
})
dev.off()
