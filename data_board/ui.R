#
# This is the user-interface definition of a Shiny web application. You can run the application by clicking 'Run App' above.
#

suppressPackageStartupMessages({
  library(shiny)
})


# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Tritra Data Board"),

  # "table"
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date_range", label="Date range (yyyy-mm-dd)",
                     start="2016-11-11", end=Sys.Date()+2,
                     min="2016-11-01", max="2099-12-31"
      ),
      selectInput("query_name", label="Query name", choices=c("hourly_trips", "databoard"),
                  selected="hourly_trips"
      )
    ),
    mainPanel(
      dataTableOutput("table")
    )
  )
))
