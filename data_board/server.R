#
# This is the server logic of a Shiny web application. You can run theapplication by clicking 'Run App' above.
#

suppressPackageStartupMessages({
  library(shiny)
  library("futile.logger")
  flog.layout(layout.format('[~t] ~l - ~m'))
  
  if (1 == 0) {
    setwd("/srv/shiny-server")  
  } else {
    setwd("~/tritra/shiny-server")  
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
  output$plottrips <- renderPlot({
    date_range <- gsub("-", "", input$date_range)
    bdata <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
    bdata$fd <- as.Date(as.POSIXct(
      as.numeric(as.POSIXct(bdata$ts, format="%Y-%m-%d"))
      , origin="1970-01-01"))
    plottrips(bdata)
  })
  output$plotsignups <- renderPlot({
    date_range <- gsub("-", "", input$date_range)
    bdata <- runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
    bdata$fd <- as.Date(as.POSIXct(
      as.numeric(as.POSIXct(bdata$ts, format="%Y-%m-%d"))
      , origin="1970-01-01"))
    plotsignups(bdata)
  })
})
