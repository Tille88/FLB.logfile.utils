#' Reads in log file
#'
#' Reads in file gotten from runnint pymavdump.py
#'
#' @param path Path to the input file
#' @return a dataframe with categories and variables collected.
#' @export
read_in_log = function(path){
  file <- readr::read_lines(path)

  # introduce new sep - "|"
  separated <- gsub("[{|}]|([[:digit:]]: )", "|", file)



  # Rename, drop empty col, make into time, seconds from start
  log_df = data.frame(matrix(stringr::str_trim(unlist(strsplit(separated, "\\|"))),
                             nrow=length(separated), byrow=T),
                      stringsAsFactors=FALSE)
  log_df$tenth_of_sec = sapply(log_df[,1], function(x) { substr(x, nchar(x), nchar(x))})
  log_df[,1] = as.POSIXct(log_df[,1])
  #log_df[,4] = NULL
  names(log_df) <- c('posix_time', 'category', 'variables', 'tenth_of_second')
  log_df = log_df %>% dplyr::mutate(seconds = posix_time - log_df$posix_time[1])
  log_df$seconds = log_df$seconds + as.numeric(log_df$tenth_of_second) * 10^-2
  return(log_df)
}
