

suppressPackageStartupMessages(suppressWarnings({
  library("futile.logger")
  library("dplyr")
  flog.layout(layout.format('[~t] ~l - ~m'))
  
  sys_ver <- Sys.info()[["version"]]
  if (grepl("Darwin", sys_ver)) {
    setwd("~/tritra/shiny-server")  # mac  
  } else if (grepl("Ubuntu", sys_ver)) {
    setwd("/srv/shiny-server")  # shiny server 
  }
  source("./queryrunner/utils/query_utils.R")
}))


################################################
################################################
# Parameter settings
# 2016-11-08 is the start date of Tritra operations!
date_range <- c("20161108", gsub("-", "", Sys.Date()+2) )

query_name <- "bikes_fraud"  # hourly_trips, databoard, bikes_fraud, users_info
secret_file <- "~/.tritra_secret"

data <- runQueryWrapperFn(query_name, date_range, secret_file=secret_file)
flog.info("ALL DONE!")
