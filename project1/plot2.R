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
dt2 <- dt

# create new column for DateTime in POSIXlt format, set date to Date format
dt2$DateTime <- strptime(paste(dt2$Date,dt2$Time,sep = " "),format="%d/%m/%Y %H:%M:%S")
dt2$Date <- as.Date(dt2$Date,format="%d/%m/%Y")

# create a data frame of datetime and global active power on feb 1-2 2007
power2 <- dt2 %>% 
  select(Date,DateTime,Global_active_power) %>% 
  filter(Date >= "2007-02-01" & Date <= "2007-02-02")
# create line chart of global active power as a function of time
plot(power2$DateTime,power2$Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)",type="l")

# open the png library for writing to png
library(png)
# open png of size 480x480, written to plot2.png, and plot the same line chart as above
png(filename="plot2.png", width = 480, height = 480)
plot(power2$DateTime,power2$Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)",type="l")
dev.off()
