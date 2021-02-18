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
dt3 <- dt

# create new column for DateTime in POSIXlt format, set date to Date format
dt3$DateTime <- strptime(paste(dt3$Date,dt3$Time,sep = " "),format="%d/%m/%Y %H:%M:%S")
dt3$Date <- as.Date(dt3$Date,format="%d/%m/%Y")

# create a data frame of datetime and submeters 1:3 on feb 1-2 2007
submeter <- dt3 %>%
  filter(Date >= "2007-02-01" & Date <= "2007-02-02") %>%
  select(DateTime,Sub_metering_1,Sub_metering_2,Sub_metering_3)
# create line chart of submeter 1 as a function of time, line color black
# add line for submeter 2, color red and submeter 3, color blue, and legend at top right
plot(submeter$DateTime, submeter$Sub_metering_1,col="black", xlab = "", ylab = "Energy sub metering",type="l")
lines(submeter$DateTime, submeter$Sub_metering_2,col="red",type="l")
lines(submeter$DateTime, submeter$Sub_metering_3,col="blue",type="l")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lty = 1)

# open the png library for writing to png
library(png)
# open png of size 480x480, written to plot3.png, and plot the same line chart as above
png(filename="plot3.png", width = 480, height = 480)
plot(submeter$DateTime, submeter$Sub_metering_1,col="black", xlab = "", ylab = "Energy sub metering",type="l")
lines(submeter$DateTime, submeter$Sub_metering_2,col="red",type="l")
lines(submeter$DateTime, submeter$Sub_metering_3,col="blue",type="l")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lty = 1)
dev.off()
