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
  source("./plot/image_utils.R") # To call plot_x
  source("./plot/input_utils.R") # To call create_col_names
  source("./queryrunner/utils/download_utils.R") # To call get_path
  
})

options(warn=1)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  #create reactive
  #trips analysis checkbox
  column_selected_1 <- reactive({
    long_col_names_1 <- create_col_names(t1="data_board",t2="bikes_fraud",t3="users_info",
                                         t4="referral",t5="all_trips",t6="bills")
    long_col_names_1 %>%
      filter(name == input$query_name_1) %>%
      select(subcolumn)
  })
  #referral checkbox
  column_selected_3 <- reactive({
    long_col_names_3 <- create_col_names(t1="data_board",t2="bikes_fraud",t3="users_info",
                                         t4="referral",t5="all_trips",t6="bills")
    long_col_names_3 %>%
      filter(name == input$query_name_3) %>%
      select(subcolumn)
    
  })  
  # Dim info checkbox
  column_selected_4 <- reactive({
    long_col_names_4 <- create_col_names(t1="data_board",t2="bikes_fraud",t3="users_info",
                                         t4="referral",t5="all_trips",t6="bills")
    long_col_names_4 %>%
      filter(name == input$query_name_4) %>%
      select(subcolumn)
  })
  #sub select
  #trips analysis column
  output$slt_column_1 <- renderUI({
    checkboxGroupInput("subcolumn_1",label = "Column", choices = column_selected_1()$subcolumn,
                       selected = "all")
  })
  #referral column
  output$slt_column_3 <- renderUI({
    checkboxGroupInput("subcolumn_3",label = "Column", choices = column_selected_3()$subcolumn,
                       selected = c("referrer_cell_phone","referrer_lifetime_referral"))
  })
  # Dim info column  
  output$slt_column_4 <- renderUI({
    checkboxGroupInput("subcolumn_4",label = "Column", choices = column_selected_4()$subcolumn,
                       selected = "all")
  })
  #### tab Trips analysis
  ## download Trips analysis
  observeEvent(input$download_trips_analysis,{
    date_range_1 <- gsub("-", "", input$date_range_1)
    bdata_daily <- runQueryWrapperFn(input$query_name_1, date_range_1, secret_file='~/.tritra_secret')
    bdata_weekly <- runQueryWrapperFn("data_board_weekly", date_range_1, secret_file='~/.tritra_secret')
    path_daily <- get_path(set_table_name = "trips_analysis_daily.csv")
    path_weekly <- get_path(set_table_name = "trips_analysis_weekly.csv")
    write.csv(bdata_daily, path_daily, row.names = F)
    write.csv(bdata_weekly, path_weekly, row.names = F)
  })
  ## daily
  # table_trips_analysis_daily
  output$table_trips_analysis_daily <- renderDataTable({
    date_range_1 <- gsub("-", "", input$date_range_1)
    bdata <- runQueryWrapperFn(input$query_name_1, date_range_1, secret_file='~/.tritra_secret')
    
    if("all" %in% input$subcolumn_1){
      bdata
    } else {
      cs <- as.matrix(input$subcolumn_1)
      bdata[,cs[,1]] 
    }
  })
  
  # plot_trips_analysis_daily
  output$plot_trips_analysis_daily <- renderPlot({
    date_range_1 <- gsub("-", "", input$date_range_1)
    bdata <- runQueryWrapperFn(input$query_name_1, date_range_1, secret_file='~/.tritra_secret')
    plot_dashboard(data=bdata)
  })
  ##weekly
  # table_trips_analysis_weekly
  output$table_trips_analysis_weekly <- renderDataTable({
    date_range_1 <- gsub("-", "", input$date_range_1)
    bdata <- runQueryWrapperFn("data_board_weekly", date_range_1, secret_file='~/.tritra_secret')
    
    if("all" %in% input$subcolumn_1){
      bdata
    } else {
      cs <- as.matrix(input$subcolumn_1)
      bdata[,cs[,1]] 
    }
  })
  
  # plot_trips_analysis_weekly
  output$plot_trips_analysis_weekly <- renderPlot({
    date_range_1 <- gsub("-", "", input$date_range_1)
    bdata <- runQueryWrapperFn("data_board_weekly", date_range_1, secret_file='~/.tritra_secret')
    plot_dashboard(data=bdata)
  })
  #### tab Hourly trips
  ## download Hourly trips
  observeEvent(input$download_hourly_trips,{
    date_range_2 <- gsub("-", "", input$date_range_2)
    bdata <- runQueryWrapperFn(input$query_name_2, date_range_2, secret_file='~/.tritra_secret')
    path <- get_path(set_table_name = "hourly_trips.csv")
    write.csv(bdata, path, row.names = F)
  })
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
  
  #### tab referral
  ## download referral
  observeEvent(input$download_referral,{
    date_range_3 <- ""
    bdata <- runQueryWrapperFn(input$query_name_3, date_range_3, secret_file='~/.tritra_secret')
    path <- get_path(set_table_name = "referral.csv")
    write.csv(bdata, path, row.names = F)
  })
  # table_referral
  output$table_referral <- renderDataTable({
    date_range_3 <- ""
    bdata <- runQueryWrapperFn(input$query_name_3, date_range_3, secret_file='~/.tritra_secret')
    if("all" %in% input$subcolumn_3){
      bdata
    } else {
      cs <- as.matrix(input$subcolumn_3)
      bdata[,cs[,1]] 
    }
  })
  
  #### tab dim info
  ## download dim info
  observeEvent(input$download_dim_info,{
    date_range_4 <- ""
    bdata <- runQueryWrapperFn(input$query_name_4, date_range_4, secret_file='~/.tritra_secret')
    path <- get_path(set_table_name = "dim_info.csv")
    write.csv(bdata, path, row.names = F)
  })
  # table_dim_info
  output$table_dim_info <- renderDataTable({
    date_range_4 <- ""
    bdata <- runQueryWrapperFn(input$query_name_4, date_range_4, secret_file='~/.tritra_secret')
    if("all" %in% input$subcolumn_4){
      bdata
    } else {
      cs <- as.matrix(input$subcolumn_4)
      bdata[,cs[,1]] 
    }
  })
})
