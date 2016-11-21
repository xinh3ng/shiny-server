

suppressPackageStartupMessages(suppressWarnings({
  library("futile.logger")
  library("dplyr")
  flog.layout(layout.format('[~t] ~l - ~m'))

  setwd("/srv/shiny-server")
  source("./queryrunner/utils/query_utils.R")
}))


################################################
################################################
# Parameter settings
# 2016-11-08 is the start date of Tritra operations!
date_range <- c("20161108", gsub("-", "", Sys.Date()+2) )

query_name <- "hourly_trips"  # hourly_trips, databoard
secret_file <- "~/.tritra_secret"

data <- runQueryWrapperFn(query_name, date_range, secret_file=secret_file)
flog.info("ALL DONE!")
