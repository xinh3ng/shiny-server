library(ggplot2)
library(reshape2)

#dashboard data reshape
reshapedashboard <- function(table,args, reshape_vars){
   table$ts_2 <- as.Date(table$ts)
    # + element
  pivot <- with(table,data_frame(ts_2,trips,paid_trips,signup,active_users,
                                 avg_ontrip_minutes,c_r,trips_paid_pct,trips_bike,
                                 active_bikes,first_trip)) #ts_2,trips,paid_trips,signup,active_users
    # stack
  j <- 1
  groupvars <- c(1:1)
  for (i in 1:length(args)) {
    if (!args[i] %in% reshape_vars) {
      groupvars[j] <- args[i]
      j <- j+1
    }
  }
  fdata = melt(data = pivot, id.vars = groupvars, value.name = "tsp", variable.name = "gtsp")
  return(fdata)
}

#plottrips
plot_dashboard <- function(data){
  ggplot(data = data ,aes(x = ts_2,y = tsp)) + #start
    geom_line(size = 0.8, color = 'blue') + geom_point(size=1.5, shape=20, color = 'black') +
    facet_wrap(~gtsp, nrow = 4, scales = 'free') +
    labs(title = "data_plot",x = "date",y = "") +
    scale_x_date (date_breaks = "1 day", date_labels = "%m-%d") +
    theme_bw() +
    theme(
      plot.title = element_text(size=20,colour = "black",face = "bold.italic"),
      axis.title.x = element_text(size=15,colour = "black",face = "bold"),
      axis.title.y = element_text(size=15,colour = "black",face = "bold"),
      axis.text.x  = element_text(size=10, angle=60, vjust=0.5,face = "plain",colour = "gray50"),
      axis.text.y = element_text(size=10,face = "plain",colour = "gray50"),
      axis.line = element_line(colour = "black",size = 1)
    )
}

#plot hourly_trips
plot_hourlytrips <- function(data){
     ggplot(data, aes(date, hour)) + #start
     geom_tile(aes(fill= completed_trips)) + #bulk value
     scale_fill_continuous(high="darkgreen", low="white", name="trips") +
     labs(title="hourly_trips", x="date", y="hourly", face = "completed_trips") +
     scale_y_continuous(breaks = c(0:24)) +
     geom_text(aes(label=round(completed_trips,2)), angle=0, size = 3) +
     theme_bw() +
     theme(
       plot.title = element_text(size=20,colour = "black",face = "bold.italic"),
       axis.title.x=element_text(size=15, face = "bold"),
       axis.title.y=element_text(size=15, face = "bold"),
       axis.text.x=element_text(size=13, colour="grey50", angle = 90, vjust = 0.5, face = "plain"),
       axis.text.y=element_text(size=15, colour="grey50",face = "plain"),
       legend.title=element_text(size=15),
       legend.text=element_text(size=10),
       panel.grid =element_blank(),
       legend.key.size = unit(0.8, "cm")
     )
}