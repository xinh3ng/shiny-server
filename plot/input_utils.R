# create table of all tables' columns with tables' name
create_col_names <- function(t1,t2,t3,t4,t5,t6){
  table <- list(t1,t2,t3,t4,t5,t6)
  all <- list(
    "col_data_board" = c("all","ts","trips","completed_trips","paid_trips","total_fare_cny","paid_fare_cny",
                         "avg_ontrip_minutes","c_r","trips_paid_pct","fare_paid_pct","trips_bike", "trips_active_bike",
                         "active_bikes","avg_fare_trip_cny","avg_fare_bike_cny","signup","first_trip",
                         "active_users","trips_user"),
    
    "col_bikes_fraud" = c("all","plate","is_in_school","bike_lt_c_trips","bike_lt_paid_trips","user_served",
                          "bike_lasttrip_time","bike_last_user","user_lt_c_trips","user_lt_paid_trips",
                          "kinds_bikes_used","user_name","user_phone","referrer","user_student_id",
                          "user_wechat_city","user_wechat_name","user_wechat_gender"),
    
    "col_users_info" = c("all","user_id","signup_time","user_lifetime_c_trips","user_lifetime_paid_trips",
                         "bike_used","user_name","user_phone","referrer","user_student_id",
                         "user_wechat_city","user_wechat_name","user_wechat_gender"),
    
    "col_referral" = c("all","referrer_cell_phone","referrer_user_id","referrer_name","referrer_account_status",
                       "referrer_lifetime_c_trips","referrer_lifetime_paid_trips","bike_used","referrer_lifetime_referral",
                       "referrer_student_id","referrer_wechat_city","referrer_wechat_name","referrer_wechat_gender"),
    
    "col_all_trips" = c("all","id","trip_id","user_id","user_name","user_phone","user_wechat_name","trip_profile",
                        "bike_id","trip_tags","pikcup_ts","dropoff_ts","duration_minutes","is_completed",
                        "updated_at","images","bill_id"),
    
    "col_bills" = c("all","id","bill_id","duration","rate","original","promo","total","is_paid",
                    "updated_at","out_trade_no")
  )
  num_1 <- length(all$col_data_board )
  num_2 <- length(all$col_bikes_fraud )
  num_3 <- length(all$col_users_info )
  num_4 <- length(all$col_referral )
  num_5 <- length(all$col_all_trips )
  num_6 <- length(all$col_bills )
  name <- data.frame(
    rep(c(as.character(table[1]), as.character(table[2]), as.character(table[3]), 
          as.character(table[4]), as.character(table[5]), as.character(table[6])),
        c(num_1,num_2,num_3,num_4,num_5,num_6))
  )
  col_1 <- data.frame(all[1])
  colnames(col_1) <- "subcolumn"
  col_2 <- data.frame(all[2])
  colnames(col_2) <- "subcolumn"
  col_3 <- data.frame(all[3])
  colnames(col_3) <- "subcolumn"
  col_4 <- data.frame(all[4])
  colnames(col_4) <- "subcolumn"
  col_5 <- data.frame(all[5])
  colnames(col_5) <- "subcolumn"
  col_6 <- data.frame(all[6])
  colnames(col_6) <- "subcolumn"
  subcolumn <- rbind(col_1,col_2,col_3,col_4,col_5,col_6)
  long_col_names <- data.frame(name,subcolumn)
  colnames(long_col_names) <- c("name","subcolumn")
  return(long_col_names)
}
