# create table of all tables' columns with tables' name
create_col_names <- function(t1,t2,t3){
  table <- list(t1,t2,t3)
  all <- list(
    "col_data_board" = c("all","ts","trips","completed_trips","paid_trips","total_fare_cny","paid_fare_cny",
                         "avg_ontrip_minutes","c_r","trips_paid_pct","fare_paid_pct","trips_bike",
                         "active_bikes","avg_fare_trip_cny","avg_fare_bike_cny","signup","first_trip",
                         "active_users","trips_user"),
    
    "col_bikes_fraud" = c("all","plate","is_in_school","bike_lt_c_trips","bike_lt_paid_trips","user_served",
                          "bike_lasttrip_time","bike_last_user","user_lt_c_trips","user_lt_paid_trips",
                          "kinds_bikes_used","user_name","user_phone","referrer","user_student_id",
                          "user_wechat_city","user_wechat_name","user_wechat_gender"),
    
    "col_users_info" = c("all","user_id","signup_time","user_lifetime_c_trips","user_lifetime_paid_trips",
                         "bike_used","user_name","user_phone","referrer","user_student_id",
                         "user_wechat_city","user_wechat_name","user_wechat_gender")
  )
  num_1 <- length(all$col_data_board )
  num_2 <- length(all$col_bikes_fraud )
  num_3 <- length(all$col_users_info )
  name <- data.frame(
    rep(c(as.character(table[1]), as.character(table[2]), as.character(table[3])),
        c(num_1,num_2,num_3))
  )
  col_1 <- data.frame(all[1])
  colnames(col_1) <- "subcolumn"
  col_2 <- data.frame(all[2])
  colnames(col_2) <- "subcolumn"
  col_3 <- data.frame(all[3])
  colnames(col_3) <- "subcolumn"
  subcolumn <- rbind(col_1,col_2,col_3)
  long_col_names <- data.frame(name,subcolumn)
  colnames(long_col_names) <- c("name","subcolumn")
  return(long_col_names)
}
