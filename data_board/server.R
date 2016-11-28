#
# This is the server logic of a Shiny web application. You can run theapplication by clicking 'Run App' above.
#

suppressPackageStartupMessages({
  library(shiny)
  library(futile.logger)
  flog.layout(layout.format('[~t] ~l - ~m'))
  
  sys_ver <- Sys.info()[["version"]]
  if (grepl("Darwin", sys_ver)) {
    setwd("~/tritra/shiny-server")  # mac  
  } else if (grepl("Ubuntu", sys_ver)) {
    setwd("/srv/shiny-server")  # shiny server 
  }
  source("./queryrunner/utils/query_utils.R")  # To call runQueryWrapperFn
  source("./plot/plot_utils.R")
})

options(warn=1)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # "table"
  output$table <- renderDataTable({
    date_range <- gsub("-", "", input$date_range)
    bdata <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
    
    if (input$query_name %in% c("data_board","bikes_fraud","users_info")) {
      bdata
    } else if (input$query_name == "hourly_trips") { #hourly_trips data reshape
      dcast(bdata, hour ~ date ,value.var = 'completed_trips')
    }
  })
  
  # plot
  output$plot <- renderPlot({
    date_range <- gsub("-", "", input$date_range)
    bdata <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
    
    if (input$query_name == "data_board") {
      plot_dashboard(data=bdata)
    } else if (input$query_name == "hourly_trips"){ #plot hourlytrips
      plot_hourlytrips(data=bdata)
    } else if (input$query_name %in% c("bikes_fraud","users_info")){
      plot_empty(data=bdata)
    }
    
  })
})
