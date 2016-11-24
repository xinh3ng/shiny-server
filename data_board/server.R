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
    table_databoard <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
    if (input$query_name == "databoard") {table_databoard}
    else if (input$query_name == "hourly_trips") {
      #hourly_trips data reshape
      table_databoard <- dcast(table_databoard,hour ~ date ,value.var = 'completed_trips')
      }
  })
  #plot dashboard
  output$plot <- renderPlot({
    date_range <- gsub("-", "", input$date_range)
    bdata <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
    
    #plot dashboard
    if (input$query_name == "databoard"){
      args <-c('ts_2','trips','paid_trips','signup','active_users')
      group <- c('trips','signup')
      ffdata <- reshapedashboard(bdata,args = args, group = group)
      plot_dashboard(ffdata)
    }
    #plot hourlytrips
    else if (input$query_name == "hourly_trips"){
      date_range <- gsub("-", "", input$date_range)
      bdata <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
      plot_hourlytrips(bdata)
      }
  })
})