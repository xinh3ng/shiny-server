#
# sql payloads
# sql file and its argument list that can run in bin/queryrunner.R
#
###########################################

suppressPackageStartupMessages(suppressWarnings({
  library("jsonlite")
}))


getSqlPayload <- function(name) {
  all <- list(
    "hourly_trips" = list(
      "query_file" = "./sql/hourly_trips.sql",
      "args" = list("start_date" = "19700101",
                    "end_date" = "20991231"
                  )
    ),
    "databoard" = list(
      "query_file" = "./sql/databoard.sql",
      "args" = list("start_date" = "19700101",
                    "end_date" = "20991231"
      )
    ),
    "bikes_fraud" = list(
      "query_file" = "./sql/bikes_fraud.sql"
    )
  )

  return(all[[name]])
}


.is_file <- function(query_file) {
  file_or_not <- file.exists(query_file)
  return(file_or_not)
}

#' Parse the sql payload
#'
#' @param payload Payload nested list from getSqlPayload() function
parseSqlPayload <- function(payload, ...) {
  args <- list(...)
  if(!.is_file(payload$query_file)) {stop("Invalid or non-existent query file")}

  query <- readLines(payload$query_file) %>% paste(., collapse=" ")
  for (name in names(args)) {
    arg <- args[[name]]
    query <- gsub(paste("{{", name, "}}", sep=""),
                  replacement=arg, x=query, fixed=T)  # replace {{arg}} with arg content
  }
  return(query)
}

