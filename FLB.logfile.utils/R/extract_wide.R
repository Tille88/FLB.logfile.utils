# Generate wide format...
extraxt_to_column = function(list_unprocessed_vars_index){
  lapply(list_unprocessed_vars)
}

#' Extracts a wide-format dataframe for a single splitted dataframe
#'
#' @param single_splitted_df A single dataframe
#' @return A wide dataframe for the variables previously a nested list
#' @export
extract_variables_wide = function(single_splitted_df){
  list_of_variables = apply(single_splitted_df, MARGIN = 1, function(x){
      lapply(
        seq_along(x$splitted_string_list), function(i){
          if(i%%2){
            as.numeric(x$splitted_string_list[[i+1]])
          }
      })
  })

  data_frame_wide = data.frame(matrix(unlist(list_of_variables),
                            ncol=length(single_splitted_df$splitted_string_list[[1]])/2,
                            byrow=T))
  colnames(data_frame_wide) = single_splitted_df$splitted_string_list[[1]][c(T,F)]
  cbind(single_splitted_df[,1], data_frame_wide)
}


#' Extracts a list of dataframes in wide formats
#'
#' @param list_of_dfs List of dataframes with nested variable column
#' @return A list of wide-formatted dataframes for the variables previously a nested list
#' @export
extract_all_in_wide = function(list_of_dfs){
  return(lapply(list_of_dfs, extract_variables_wide))
}
