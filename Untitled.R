library(ggplot2)
#import data
bdata <- read.csv("~/Desktop/databoard.csv")
bdata$cc <- as.Date(as.POSIXct(
  as.numeric(as.POSIXct(bdata$date, format="%Y-%m-%d"))
  , origin="1970-01-01"))


cc <- data_frame(bdata$trips,bdata$paid_trips)
#plot
ggplot(data = bdata,aes(x = cc,y = trips)) + #start
  
  geom_line(size = 2, color = 'blue') + geom_point(size=2, shape=20) +
  scale_x_date (date_breaks = "1 day") +
  theme(
    plot.title = element_text(size=20,colour = "blue",face = "bold"),
    axis.title.x = element_text(size=15,colour = "black",face = "bold"),
    axis.title.y = element_text(size=15,colour = "black",face = "bold"),
    axis.text.y = element_text(size=10,colour = "red",face = "plain"),
    axis.text.x  = element_text(angle=60, vjust=0.5,face = "plain"),
    axis.line = element_line(colour = "black",size = 1)
    
  )
par(mar=c(6,6,6,6))
