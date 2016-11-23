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
    runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
  })
  #plot
  output$plotdashboard <- renderPlot({
    date_range <- gsub("-", "", input$date_range)
    bdata <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
    args <-c('ts_2','trips','paid_trips','signup','active_users')
    group <- c('trips','signup')
    ffdata <- reshapedata(bdata,args = args, group = group)
    plotdashboad(ffdata)
  })
})
