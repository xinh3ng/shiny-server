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
      "args" = list("start_date" = "yyyymmdd [hhmmss]",
                   "end_date" = "yyyymmdd [hhmmss]"
                  )
    ),
    "databoard" = list(
      "query_file" = "./sql/databoard.sql",
      "args" = list("start_date" = "yyyymmdd [hhmmss]",
                    "end_date" = "yyyymmdd [hhmmss]"
      )
    )
  )

  return(all[[name]])
}


.isFile <- function(query_file) {
  file_or_not <- file.exists(query_file)
  return(file_or_not)
}

#' Parse the sql payload
#'
#' @param payload Payload nested list from getSqlPayload() function
parseSqlPayload <- function(payload, ...) {
  args <- list(...)
  if(!.isFile(payload$query_file)) {stop("Invalid or non-existent query file")}

  query <- readLines(payload$query_file) %>% paste(., collapse=" ")
  for (name in names(args)) {
    if(is.character(args[[name]])) {  # if arg is in string format
      arg <- paste("'", args[[name]], "'", sep="")  # add ' ' around it
    } else {
      arg <- args[[name]]
    }
    query <- gsub(paste("{{", name, "}}", sep=""),
                  replacement=arg, x=query, fixed=T)  # replace {{arg}} with arg content
  }
  return(query)
}

