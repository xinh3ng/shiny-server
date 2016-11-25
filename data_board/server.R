#
# This is the server logic of a Shiny web application. You can run theapplication by clicking 'Run App' above.
#

suppressPackageStartupMessages({
  library(shiny)
  library("futile.logger")
  flog.layout(layout.format('[~t] ~l - ~m'))
  
  sys_ver <- Sys.info()[["version"]]
  if (grepl("Darwin", sys_ver)) {
    setwd("~/tritra/shiny-server")  # mac  
  } else if (grepl("Ubuntu", sys_ver)) {
    setwd("/srv/shiny-server")  # shiny server 
  }
  source("./queryrunner/utils/query_utils.R")  # To call runQueryWrapperFn
  source("./plot/dashboard_line.R") # To call plotdashboad
})


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  # "table"
  output$table <- renderDataTable({
    date_range <- gsub("-", "", input$date_range)
    bdata <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
    if (input$query_name == "databoard") {
      bdata
    } else if (input$query_name == "hourly_trips") { #hourly_trips data reshape
      dcast(bdata, hour ~ date ,value.var = 'completed_trips')
    }
  })
  
  # plot dashboard
  output$plot <- renderPlot({
    date_range <- gsub("-", "", input$date_range)
    bdata <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
    
    if (input$query_name == "databoard"){  #plot databoard
      args <-c('ts_2','trips','paid_trips','signup','active_users','avg_ontrip_minutes',
               'c_r','trips_paid_pct','trips_bike','active_bikes','first_trip')
      group <- c('trips','signup','avg_ontrip_minutes','c_r','trips_paid_pct',
                 'trips_bike','active_bikes','active_users','first_trip')
      ffdata <- reshapedashboard(table = bdata, args = args, reshape_vars = group)
      plot_dashboard(data = ffdata)
      
    } else if (input$query_name == "hourly_trips"){ #plot hourlytrips
      plot_hourlytrips(data = bdata)
    }
  
  })
})