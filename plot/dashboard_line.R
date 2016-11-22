library(ggplot2)

#trips
plottrips <- function(name){
  ggplot(data = name,aes(x = fd,y = trips)) + #start
    geom_line(size = 0.8, color = 'blue') + geom_point(size=2, shape=20, color = 'black') +
    labs(title = "daily_trips",x = "date",y = "trips") +
    scale_x_date (date_breaks = "1 day") +
    theme(
      plot.title = element_text(size=20,colour = "black",face = "bold"),
      axis.title.x = element_text(size=15,colour = "black",face = "bold"),
      axis.title.y = element_text(size=15,colour = "black",face = "bold"),
      axis.text.x  = element_text(angle=60, vjust=0.5,face = "plain"),
      axis.text.y = element_text(size=10,colour = "red",face = "plain"),
      axis.line = element_line(colour = "black",size = 1)
    )
}
#signup
plotsignups <- function(name){
  ggplot(data = name,aes(x = fd,y = signup)) + #start
    geom_line(size = 0.8, color = 'blue') + geom_point(size=2, shape=20, color = 'black') +
    labs(title = "daily_signups",x = "date",y = "signups") +
    scale_x_date (date_breaks = "1 day") +
    theme(
      plot.title = element_text(size=20,colour = "black",face = "bold"),
      axis.title.x = element_text(size=15,colour = "black",face = "bold"),
      axis.title.y = element_text(size=15,colour = "black",face = "bold"),
      axis.text.x  = element_text(angle=60, vjust=0.5,face = "plain"),
      axis.text.y = element_text(size=10,colour = "red",face = "plain"),
      axis.line = element_line(colour = "black",size = 1)
    )
}