
suppressPackageStartupMessages(suppressWarnings({
  library("RPostgreSQL")
  library("jsonlite")
  library("futile.logger")
  library("dplyr")

  source("./queryrunner/sql_payloads/payloads.R")
}))



#' Load secret file
.loadSecret <- function(secret_file) {
  secret <- fromJSON(secret_file)
  return(secret)
}

#' Create connection
createCon <- function(driver=dbDriver("PostgreSQL"), secret_file="~/.tritra_secret") {
  secret = .loadSecret(secret_file)
  con <- dbConnect(drv=driver, user=secret$user, password=secret$password, host=secret$host,
                   dbname=secret$database, port=as.integer(secret$port)
  )
  return(list("driver"=driver, "con"=con))
}


#' Run sql query
#'
#' @param query A query string
#'
runQuery <- function(con, query) {
  df <- dbGetQuery(conn=con, statement=query)
  return(df)
}


#'
#' @param query_name Options hourly_trips, databoard
runQueryWrapperFn <- function(query_name, date_range, secret_file="~/.tritra_secret") {

  flog.info("Starting a db connection")
  con_inst <- createCon(driver=dbDriver("PostgreSQL"), secret_file=secret_file)
  flog.info("db connection is created")

  payload <- getSqlPayload(query_name)
  query <- parseSqlPayload(payload=payload, start_date=date_range[1], end_date=date_range[2])

  data <- runQuery(con=con_inst$con, query=query)
  flog.info("Data query is finished")

  # Close conections
  dbDisconnect(con_inst$con)
  flog.info("db connection off")

  return(data)
}
