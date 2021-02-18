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
dt1 <- dt

# set date into the Date format
dt1$Date <- as.Date(dt1$Date,format="%d/%m/%Y")

# create a data frame of date and global active power on feb 1-2 2007
power <- dt1 %>% 
  select(Date,Global_active_power) %>% 
  filter(Date >= "2007-02-01" & Date <= "2007-02-02")
# histogram plot of global active power
hist(power$Global_active_power, xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power", col = "red")

# open the png library for writing to png
library(png)
# open png of size 480x480, written to plot1.png, and plot the same histogram as above
png(filename="plot1.png", width = 480, height = 480)
hist(power$Global_active_power, xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power", col = "red")
dev.off()
