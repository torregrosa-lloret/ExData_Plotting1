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
hist(data$Global_active_power, main = "Global Active Power", 
     xlab = " Global Active Power (kilowatts)",
     col = "red")
dev.copy(png, file = "plot1.png") ## Copy my plot to a PNG file
dev.off()
