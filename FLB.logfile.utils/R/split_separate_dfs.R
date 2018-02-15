convert_to_nested_list = function(str){
  splitted = stringr::str_split(str, pattern = "[:|,]")
  unlisted = unlist(splitted)
  trimmed = stringr::str_trim(unlisted)
  return(list(trimmed))
}

#' Reads in raw dataframe and splits to list of different splitted dataframes
#'
#' @param log_df A parsed dataframe after reading in file
#' @return List of dataframes for each category
#' @export
split_separate_dfs = function(log_df){
  genrate_nested_list_variable = log_df %>%
            dplyr::group_by(category, row_number()) %>%
            dplyr::mutate(splitted_string_list = convert_to_nested_list(variables))
  split_by_category = split(genrate_nested_list_variable,
                            genrate_nested_list_variable$category)
  return(split_by_category)
}
