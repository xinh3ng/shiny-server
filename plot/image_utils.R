suppressPackageStartupMessages({
  library(ggplot2)
  library(reshape2) 
  library(dplyr)
})


# Private function: dashboard data reshape
.reshape_dashboard <- function(table, args, reshape_vars){
  table$ts <- as.Date(table$ts)
  # + element
  pivot <- with(table,data_frame(ts,trips,paid_trips,signup,active_users,
                                 avg_ontrip_minutes,c_r,trips_paid_pct,trips_active_bike,
                                 active_bikes,first_trip)) # plot axis_y
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


plot_dashboard <- function(data){
  args <- c('ts','trips','paid_trips','signup','active_users','avg_ontrip_minutes',
           'c_r','trips_paid_pct','trips_bike','active_bikes','first_trip')
  group <- c('trips','signup','avg_ontrip_minutes','c_r','trips_paid_pct',
             'trips_bike','active_bikes','active_users','first_trip')
  ffdata <- .reshape_dashboard(table = data, args = args, reshape_vars = group)
  
  row_ts <- length(ffdata$ts) #auto_axis_x breaks
  kinds_gtsp <- length(unique(ffdata$gtsp))
  if (row_ts/kinds_gtsp < 10){ 
    breaks <- "1 day"
  } else if ((row_ts/kinds_gtsp >= 10) && (row_ts/kinds_gtsp < 30)){
    breaks <- "2 days"
  } else if (row_ts/kinds_gtsp >= 30){
    breaks <- "3 days"  
  }
  ggplot(data = ffdata ,aes(x = ts,y = tsp)) + #start
    geom_line(size = 0.8, color = 'blue') + geom_point(size=1.5, shape=20, color = 'black') +
    facet_wrap(~gtsp, nrow = 4, scales = 'free') +
    labs(title = "data_plot",x = "date",y = "") +
    scale_x_date (date_breaks = breaks, date_labels = "%m-%d") +
    theme_bw() +
    theme(
      plot.title = element_text(size=20,colour = "black",face = "bold.italic"),
      axis.title.x = element_text(size=15,colour = "black",face = "bold"),
      axis.title.y = element_text(size=15,colour = "black",face = "bold"),
      axis.text.x  = element_text(size=10, angle=90, vjust=0.5,face = "bold",colour = "gray50"),
      axis.text.y = element_text(size=10,face = "bold",colour = "gray50"),
      axis.line = element_line(colour = "black",size = 1)
    )
}

# plot hourly_trips
plot_hourlytrips <- function(data){
  ggplot(data, aes(date, hour)) + #start
    geom_tile(aes(fill= completed_trips)) +
    scale_fill_continuous(high="darkgreen", low="white", name="trips") +
    labs(title="hourly_trips", x="date", y="hourly", face = "completed_trips") +
    scale_y_continuous(breaks = c(0:24)) +
    geom_text(aes(label=round(completed_trips,2)), angle=0, size = 3) + #bulk value
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
# plot hourlytrips_dod
  # create table hourlytrips_dod
cal_hourly_trips_dod <- function(data){
  i <- 1 # rows
  j <- length(data[0,]) # columns
  m <- 1
  dod <- matrix(1,24,length(data[0,]))
  dod <- data.frame(dod)
  colnames(dod) <- colnames(data) # copy tabel header
  for (m in 1:24){
    dod[m,1] <- data[m,1]# copy column 'hour'
    dod[m,2] <- 0#
    m <- m+1
  }
  
  for(j in 3:length(data[0,]) ){
    for(i in 1:24 ){
      if ( is.na(data[i,j]) ){
        dod[i,j] <- 0#
      } else if (data[i,j-1] == 0){
        dod[i,j] <- -1
      } else{
        dod[i,j] <- (data[i,j] / data[i,j-1]) - 1
        i <- i + 1
      }
    }
    i <- 1
    j <- j - 1
  }
  dod <- melt(data = dod, id.vars = "hour", value.name = "dod_growth_pct", variable.name = "date")# wide -> long
  return(dod)
}
  #plot hourlytrips_dod
plot_hourlytrips_dod <- function(data){
  ggplot(data, aes(date, hour)) + #start
    geom_tile(aes(fill=dod_growth_pct)) + 
    scale_fill_gradient(low="grey", high="darkred",name="dod_growth_pct") +
    labs(title="dod_growth", x="date", y="hourly", face = "dod_growth_pct") +
    scale_y_continuous(breaks = c(0:24)) +
   # geom_text(aes(label=round(dod_growth_pct,2)), angle=0, size = 3) + #bulk value
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
