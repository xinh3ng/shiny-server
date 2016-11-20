

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
query_name <- "hourly_trips"  # hourly_trips, databoard
date_range <- c("20161101", "20171118")
secret_file <- "~/.tritra_secret"

data <- runQueryWrapperFn(query_name, date_range, secret_file=secret_file)
flog.info("ALL DONE!")
