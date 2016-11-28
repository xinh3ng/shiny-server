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
                    "end_date" = "20991231"),
      "column" = c("ts","trips","completed_trips","paid_trips","total_fare_cny","paid_fare_cny",
                   "avg_ontrip_minutes","c_r","trips_paid_pct","fare_paid_pct","trips_bike",
                   "active_bikes","avg_fare_trip_cny","avg_fare_bike_cny","signup","first_trip",
                   "active_users","trips_user")
    ),
    "bikes_fraud" = list(
      "query_file" = "./queryrunner/sql/bikes_fraud.sql",
      "args" = list(),
      "column" = c("plate","is_in_school","bike_lt_c_trips","bike_lt_paid_trips","user_served",
                   "bike_lasttrip_time","bike_last_user","user_lt_c_trips","user_lt_paid_trips",
                   "kinds_bikes_used","user_name","user_phone","referrer","user_student_id",
                   "user_wechat_city","user_wechat_name","user_wechat_gender")
    ),
    "users_info" = list(
      "query_file" = "./queryrunner/sql/users_info.sql",
      "args" = list(),
      "column" = c("user_id","signup_time","user_lifetime_c_trips","user_lifetime_paid_trips",
                  "bike_used","user_name","user_phone","referrer","user_student_id",
                  "user_wechat_city","user_wechat_name","user_wechat_gender")
    )
  )
  
  return(all[[name]])
}
.create_col_names <- function(...){
  a <- c(...)
  num_1 <- length(getSqlPayload(a[1])$column)
  num_2 <- length(getSqlPayload(a[2])$column)
  num_3 <- length(getSqlPayload(a[3])$column)
  name <- data.frame(
    rep(c(a[1],a[2],a[3]),
    c(num_1,num_2,num_3))
  )
  col_1 <- data.frame(getSqlPayload(a[1])$column)
  colnames(col_1) <- "subcolumn"
  col_2 <- data.frame(getSqlPayload(a[2])$column)
  colnames(col_2) <- "subcolumn"
  col_3 <- data.frame(getSqlPayload(a[3])$column)
  colnames(col_3) <- "subcolumn"
  subcolumn <- rbind(col_1,col_2,col_3)
  long_col_names <- data.frame(name,subcolumn)
  colnames(long_col_names) <- c("name","subcolumn")
  return(long_col_names)
}
