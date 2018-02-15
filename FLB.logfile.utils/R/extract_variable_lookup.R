extract_variable_list = function(str){
                          splitted = stringr::str_split(str, pattern = "[:|,]")
                          unlisted = unlist(splitted)[c(T,F)]#[c(T,F)]
                          trimmed = stringr::str_trim(unlisted)
                          return(list(trimmed))
}

#' Generates a lookup table for variables and categories
#'
#' @param log_df A parsed dataframe after reading in file
#' @return Lookup table 
#' @export
extract_variable_lookup = function(log_df) {
  unduplicated_categories = log_df[!duplicated(log_df$category),2:3]
  unduplicated_categories_w_nested = unduplicated_categories %>%
    dplyr::group_by(category) %>%
    dplyr::mutate(nested_variable_list = extract_variable_list(variables))

  unduplicated_list_of_dfs = apply(unduplicated_categories_w_nested, MARGIN = 1, function(x) {
    new_varialbes_to_list = data.frame("category" = x$category,
                                       "variables" = x$nested_variable_list)
  })

  full_lookup_variables = data.table::rbindlist(unduplicated_list_of_dfs)

  return(full_lookup_variables)
}
