library(ggplot2)
library(reshape2)

#data reshape
reshapedata <- function(name,args, group){
 if("trips" %in% names(name)){
   name$ts_2 <- as.Date(as.POSIXct(
    as.numeric(as.POSIXct(name$ts, format="%Y-%m-%d"))
    , origin="1970-01-01"))
    # + element
  pivot <- with(name,data_frame(ts_2,trips,paid_trips,signup,active_users)) #ts_2,trips,paid_trips,signup,active_users
    # stack
  j <- 1
  groupvars <- c(1:1)
  for (i in 1:length(args)) {
    if (!args[i] %in% group) {
      groupvars[j] <- args[i]
      j <- j+1
    }
  }
  fdata = melt(data = pivot, id.vars = groupvars, value.name = "tsp", variable.name = "gtsp")
  return(fdata)
 } else {}
}

#plottrips
plotdashboad <- function(name){
  if("tsp" %in% names(name)){
  ggplot(data = name ,aes(x = ts_2,y = tsp)) + #start
    geom_line(size = 0.8, color = 'blue') + geom_point(size=1.5, shape=20, color = 'black') +
    facet_wrap(~gtsp, nrow = 2, scales = 'free_y') +
    labs(title = "",x = "date",y = "") +
    scale_x_date (date_breaks = "1 day") +
    theme(
      plot.title = element_text(size=20,colour = "black",face = "bold"),
      axis.title.x = element_text(size=15,colour = "black",face = "bold"),
      axis.title.y = element_text(size=15,colour = "black",face = "bold"),
      axis.text.x  = element_text(angle=60, vjust=0.5,face = "plain"),
      axis.text.y = element_text(size=10,colour = "red",face = "plain"),
      axis.line = element_line(colour = "black",size = 1)
    )
  } else {}
}