#
# sql payloads
# sql file and its argument list that can run in bin/queryrunner.R
#
###########################################

suppressPackageStartupMessages(suppressWarnings({
  library("jsonlite")
}))

#' SQL payload configurations
getSqlPayload <- function(name) {
  all <- list(
    "hourly_trips" = list(
      "query_file" = "./queryrunner/sql/hourly_trips.sql",
      "args" = list("start_date" = "19700101",
                    "end_date" = "20991231")
    ),
    "data_board" = list(
      "query_file" = "./queryrunner/sql/data_board.sql",
      "args" = list("start_date" = "19700101",
                    "end_date" = "20991231")
    ),
    "bikes_fraud" = list(
      "query_file" = "./queryrunner/sql/bikes_fraud.sql",
      "args" = list()
    ),
    "users_info" = list(
      "query_file" = "./queryrunner/sql/users_info.sql",
      "args" = list()
    )
  )
  
  return(all[[name]])
}

length_table_names <- read.csv("./queryrunner/sql_config/length_table_names.csv")
