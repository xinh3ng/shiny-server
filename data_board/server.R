#
# This is the server logic of a Shiny web application. You can run theapplication by clicking 'Run App' above.
#

suppressPackageStartupMessages({
  library(shiny)
  library(futile.logger)
  library(shinydashboard)
  flog.layout(layout.format('[~t] ~l - ~m'))
  
  sys_ver <- Sys.info()[["version"]]
  if (grepl("Darwin", sys_ver)) {
    setwd("~/tritra/shiny-server")  # mac  
  } else if (grepl("Ubuntu", sys_ver)) {
    setwd("/srv/shiny-server")  # shiny server 
  }
  source("./queryrunner/utils/query_utils.R")  # To call runQueryWrapperFn
  source("./plot/image_utils.R")
  source("./plot/input_utils.R")
})

options(warn=1)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  #create reactive
  column_selected_1 <- reactive({
    long_col_names_1 <- create_col_names(t1="data_board",t2="bikes_fraud",t3="users_info")
    long_col_names_1 %>%
      filter(name == input$query_name_1) %>%
      select(subcolumn)
  })
  
  column_selected_3 <- reactive({
    long_col_names_3 <- create_col_names(t1="data_board",t2="bikes_fraud",t3="users_info")
    long_col_names_3 %>%
      filter(name == input$query_name_3) %>%
      select(subcolumn)
  })
  #sub select
  output$slt_column_1 <- renderUI({
    checkboxGroupInput("subcolumn_1",label = "Column", choices = column_selected_1()$subcolumn, selected = "all")
  })
  
  output$slt_column_3 <- renderUI({
    checkboxGroupInput("subcolumn_3",label = "Column", choices = column_selected_3()$subcolumn, selected = "all")
  })
#### tab Trips analysis
  # "table_trips_analysis"
  output$table_trips_analysis <- renderDataTable({
    date_range_1 <- gsub("-", "", input$date_range_1)
    bdata <- runQueryWrapperFn(input$query_name_1, date_range_1, secret_file='~/.tritra_secret')
    
      if("all" %in% input$subcolumn_1){
        bdata
      } else {
        cs <- as.matrix(input$subcolumn_1)
        bdata[,cs[,1]] 
      }
  })
  
  # plot_trips_analysis
  output$plot_trips_analysis <- renderPlot({
    date_range_1 <- gsub("-", "", input$date_range_1)
    bdata <- runQueryWrapperFn(input$query_name_1, date_range_1, secret_file='~/.tritra_secret')
      plot_dashboard(data=bdata)
  })
#### tab Hourly trips
  # table_hourly_trips
  output$table_hourly_trips <- renderDataTable({
    date_range_2 <- gsub("-", "", input$date_range_2)
    bdata <- runQueryWrapperFn(input$query_name_2, date_range_2, secret_file='~/.tritra_secret')
      dcast(bdata, hour ~ date ,value.var = 'completed_trips')
  })
  
  # plot_hourly_trips
  output$plot_hourly_trips <- renderPlot({
    date_range_2 <- gsub("-", "", input$date_range_2)
    bdata <- runQueryWrapperFn(input$query_name_2, date_range_2, secret_file='~/.tritra_secret')
      plot_hourlytrips(data=bdata)
  })
  output$plot_hourly_trips_dod <- renderPlot({
    date_range_2 <- gsub("-", "", input$date_range_2)
    bdata <- runQueryWrapperFn(input$query_name_2, date_range_2, secret_file='~/.tritra_secret')
    bdata <- dcast(bdata, hour ~ date ,value.var = 'completed_trips') #long table -> wide table
    bdata_dod <- cal_hourly_trips_dod(data=bdata) # calculation wide table & -> long table
    plot_hourlytrips_dod(data=bdata_dod)
  })

#### tab User/Bike info
  # table_ub_info
  output$table_ub_info <- renderDataTable({
    date_range_3 <- gsub("-", "", input$date_range_3)
    bdata <- runQueryWrapperFn(input$query_name_3, date_range_3, secret_file='~/.tritra_secret')
      if("all" %in% input$subcolumn_3){
        bdata
      } else {
        cs <- as.matrix(input$subcolumn_3)
        bdata[,cs[,1]] 
      }
  })
  
  # plot_ub_info empty
})
