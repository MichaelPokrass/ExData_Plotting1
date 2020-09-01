eda_data <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)
eda_data$Date <- as.Date(eda_data$Date, "%d/%m/%Y")
data <- subset(eda_data, eda_data$Date == "2007-02-01" | eda_data$Date == "2007-02-02")


datetime <- paste(data$Date, data$Time)
datetime <- format(datetime, format = "%Y-%m-%d %H:%M:%S", tz="", usetz = FALSE)
data$datetime <- as.POSIXct(datetime)


data$Global_active_power <- as.numeric(data$Global_active_power)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Voltage <- as.numeric(data$Voltage)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)

require(ggplot2)
require(scales)
require(reshape2)
require(gridExtra)

p1 <- ggplot(aes(x=datetime, y=Global_active_power), data = data) + geom_line() + xlab("") + 
  ylab("Global Active Power (kilowatts)") + 
  scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%a")) +
  theme(panel.background = element_blank(),
        panel.border = element_rect(color = 'black', fill = NA, size = 1))

p2 <- ggplot(aes(x=datetime, y=Voltage), data = data) + geom_line() + xlab("datetime") + 
  ylab("Voltage") + 
  scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%a")) +
  theme(panel.background = element_blank(),
        panel.border = element_rect(color = 'black', fill = NA, size = 1))
  
p3 <- ggplot(data = melt(data,
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
        legend.text = element_text(size = 8),
        legend.key.size = unit(0.4,"line"),
        legend.spacing.y = unit(0.1, 'cm'),
        panel.background = element_blank(),
        panel.border = element_rect(color = 'black', fill = NA, size = 1))

p4 <- ggplot(aes(x=datetime, y=Global_reactive_power), data = data) + geom_line() + xlab("datetime") + 
  ylab("Global_reactive_power") + 
  scale_x_datetime(breaks = date_breaks("1 day"), labels = date_format("%a")) +
  theme(panel.background = element_blank(),
        panel.border = element_rect(color = 'black', fill = NA, size = 1))


png(file = "plot4.png", height = 480, width = 480, units = "px")
grid.arrange(p1,p2,p3,p4, nrow = 2, ncol = 2)
dev.off()