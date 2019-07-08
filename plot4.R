## Load libraries
library(lubridate)
library(dplyr)

## Download data
if(!file.exists("./data")){dir.create("./data")}  # Create data dir if it doesn't exist
if(!file.exists("./data/household_power_consumption.txt")){  # Download data if it doesn't exist
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, destfile = "./data/powerConsumption.zip")
        unzip("./data/powerConsumption.zip", exdir = "./data")
        file.remove("./data/powerConsumption.zip")  # Remove zip file
}

## Load raw data
rawData <- read.table("./data/household_power_consumption.txt", sep=";", header = TRUE,
                      stringsAsFactors = FALSE)

## Curate data
rawData[,3:9] <- lapply(rawData[,3:9], as.numeric)
rawData$Date_Time <- dmy_hms(paste(rawData$Date, rawData$Time))

data <- rawData %>% select(Date_Time, Global_active_power:Sub_metering_3) %>% 
        filter(Date_Time >= ymd("2007-02-01") & Date_Time < ymd("2007-02-03"))

## Plot data
png("plot4.png", width=480, height=480)

par(mfrow = c(2,2))

# Global Active Power ~ day
plot(x = data$Date_Time, y = data$Global_active_power, 
     xlab = "",
     ylab = "Global Active Power",
     type = "l")

# Voltage ~ day
plot(x = data$Date_Time, y = data$Voltage, 
     xlab = "datetime",
     ylab = "Voltage",
     type = "l")

# Energy submetering ~ day
plot(x = data$Date_Time, y = data$Sub_metering_1, 
     xlab = "",
     ylab = "Energy sub metering",
     type = "l")
lines(x = data$Date_Time, y = data$Sub_metering_2, 
      col = "red")
lines(x = data$Date_Time, y = data$Sub_metering_3, 
      col = "blue")
legend("topright", lty=c(1,1), col = c("black", "red", "blue"), 
       legend = names(data[,6:8]),
       bty = "n",
       cex = 0.8)

# Global reactive power ~ day
plot(x = data$Date_Time, y = data$Global_reactive_power, 
     xlab = "datetime",
     ylab = "Global_reactive_power",
     type = "l")

dev.off()
