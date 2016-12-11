#get path to save data.csv
get_path <- function(set_table_name){
  sys_name <- Sys.info()[["sysname"]]
  if (grepl("Darwin", sys_name)) {
    path <- "~/Desktop/" # mac  
  } else if (grepl("windows", sys_name)) {
    path <- "c:/tritra_data/" #pc
  }
  paste(path,set_table_name,sep = "")
}

