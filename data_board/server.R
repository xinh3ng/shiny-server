#
# This is the server logic of a Shiny web application. You can run theapplication by clicking 'Run App' above.
#

suppressPackageStartupMessages({
  library(shiny)
  library("futile.logger")
  flog.layout(layout.format('[~t] ~l - ~m'))

  setwd("/srv/shiny-server")
  source("./queryrunner/utils/query_utils.R")  # To call runQueryWrapperFn
})


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # "table"
  output$table <- renderDataTable({
    date_range <- gsub("-", "", input$date_range)
    runQueryWrapperFn(input$query_name, date_range, secret_file='~/.tritra_secret')
  })
})
