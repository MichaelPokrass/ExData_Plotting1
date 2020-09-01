eda_data <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)
eda_data$Date <- as.Date(eda_data$Date, "%d/%m/%Y")
data <- subset(eda_data, eda_data$Date == "2007-02-01" | eda_data$Date == "2007-02-02")


datetime <- paste(data$Date, data$Time)
datetime <- format(datetime, format = "%Y-%m-%d %H:%M:%S", tz="", usetz = FALSE)
data$datetime <- as.POSIXct(datetime)


data$Global_active_power <- as.numeric(data$Global_active_power)

require(ggplot2)
require(scales)

p <- ggplot(aes(x=datetime, y=Global_active_power), data = data) + geom_line() + xlab("") + 
  ylab("Global Active Power (kilowatts)") + 
  scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%a")) +
  theme(panel.background = element_blank(),
        panel.border = element_rect(color = 'black', fill = NA, size = 1))



png(file = "plot2.png", height = 480, width = 480, units = "px")
print(p)
dev.off()
