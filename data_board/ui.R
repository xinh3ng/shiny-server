#
# This is the user-interface definition of a Shiny web application. You can run the application by clicking 'Run App' above.
#

suppressPackageStartupMessages({
  library(shiny)
})


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Welcome Tritraer"),
# navbar setting
 tagList(
   navbarPage(
     h2("TriTra board"),
#### navbar1
     tabPanel(h4("Trips analysis"),
              # "table"
              sidebarLayout(
                sidebarPanel(
                  dateRangeInput("date_range_1", label="Date range (yyyy-mm-dd)",
                                 start="2016-11-08", end=Sys.Date()+2,
                                 min="2016-11-01", max="2099-12-31"
                  ),
                  selectInput("query_name_1", label="Query name", choices=c( "data_board"),
                              selected="data_board"
                  ),
                  uiOutput("slt_column_1")
                ),
                mainPanel(
                  ## <- tabset
                        tabsetPanel(
                          tabPanel("daily",
                                   plotOutput("plot_trips_analysis_daily"),
                                   dataTableOutput("table_trips_analysis_daily")
                          ), # end tab1
                          tabPanel("weekly",
                                   plotOutput("plot_trips_analysis_weekly"),
                                   dataTableOutput("table_trips_analysis_weekly")
                          ) # end tab2
                        ) # end tabsetPanel
                  
                ) # end mainPanel1
              ) # end siderbarLayout1
     ), # end navbar1

#### navbar 2
  tabPanel(h4("Hourly trips"),
           sidebarLayout(
             sidebarPanel(
               dateRangeInput("date_range_2", label="Date range (yyyy-mm-dd)",
                              start="2016-11-08", end=Sys.Date()+2,
                              min="2016-11-01", max="2099-12-31"
               ),
               selectInput("query_name_2", label="Query name", choices=c("hourly_trips"),
                           selected="hourly_trips"
               )
             ),
             mainPanel(
               plotOutput("plot_hourly_trips"),
               plotOutput("plot_hourly_trips_dod"),
               dataTableOutput("table_hourly_trips")
             ) # end mainPanel2
           ) # end siderbarLayout2
   ), # end navbar2

# end navbar3
  tabPanel(h4("Referral"),
           sidebarLayout(
             sidebarPanel(
               selectInput("query_name_3", label="Query name", choices=c("referral"),
                           selected="referral"
               ),
               uiOutput("slt_column_3")
             ),
             mainPanel(
               dataTableOutput("table_referral")
             ) # end mainPanel3
           ) # end siderbarLayout3
  ), 

# end navbar4
  tabPanel(h4("Dim info"),
           sidebarLayout(
             sidebarPanel(
               selectInput("query_name_4", label="Query name", choices=c("bikes_fraud","users_info","all_trips"),
                           selected="bikes_fraud"
               ),
               uiOutput("slt_column_4")
             ),
             mainPanel(
               dataTableOutput("table_ub_info")
             ) # end mainPanel3
           ) # end siderbarLayout3
  ) # end navbar3
  )# end navbarPage 
  ) # end tagList
))
