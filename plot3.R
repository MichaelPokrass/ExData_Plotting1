eda_data <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)
eda_data$Date <- as.Date(eda_data$Date, "%d/%m/%Y")
data <- subset(eda_data, eda_data$Date == "2007-02-01" | eda_data$Date == "2007-02-02")


datetime <- paste(data$Date, data$Time)
datetime <- format(datetime, format = "%Y-%m-%d %H:%M:%S", tz="", usetz = FALSE)
data$datetime <- as.POSIXct(datetime)


data$Global_active_power <- as.numeric(data$Global_active_power)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)

require(ggplot2)
require(scales)
require(reshape2)

p <- ggplot(data = melt(data,
                        id.var="datetime", 
                        measure.vars = c("Sub_metering_1",
                                         "Sub_metering_2",
                                         "Sub_metering_3")), 
            aes(x=datetime, y=value)) + 
  geom_line(aes(color = variable, group = variable)) +
  xlab("") + 
  ylab("Energy sub metering") + 
  scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%a")) +
  scale_color_manual(values = c("black", "red", "blue")) +
  theme(legend.position = c(0.95, 0.95),
        legend.justification = c("right","top"),
        legend.title = element_blank(),
        legend.box.background = element_rect(),
        panel.background = element_blank(),
        panel.border = element_rect(color = 'black', fill = NA, size = 1))

png(file = "plot3.png", height = 480, width = 480, units = "px")
print(p)
dev.off()