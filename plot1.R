eda_data <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)
eda_data$Date <- as.Date(eda_data$Date, "%d/%m/%Y")
data <- subset(eda_data, eda_data$Date == "2007-02-01" | eda_data$Date == "2007-02-02")

png(file = "plot1.png", height = 480, width = 480, units = "px")

hist(as.numeric(data$Global_active_power), xlab = "Global Active Power (kilowatts)",
     col = "red", main = "Global Active Power")

dev.off()


