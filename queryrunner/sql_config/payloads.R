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
    ),
    "referral" = list(
      "query_file" = "./queryrunner/sql/referral.sql",
      "args" = list()
    ),
    "all_trips" = list(
      "query_file" = "./queryrunner/sql/all_trips.sql",
      "args" = list()
    ),
    "data_board_weekly" = list(
      "query_file" = "./queryrunner/sql/data_board_weekly.sql",
      "args" = list()
    )
  )
  
  return(all[[name]])
}