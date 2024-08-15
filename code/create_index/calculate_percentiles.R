calculate_percentiles <- function(data, id_column) {
  #To convert all non-percentile columns into percentiles: 
  
  #Create a final dataframe (copy) with columns as percentiles and confirm numeric data 
  final_df <- data
  
  #Impute NAs to 0s 
  final_df[is.na(final_df)] <- 0
  
  #Check data is numeric and convert to numeric otherwise
  for (col in (colnames(final_df))) {
    if (col != id_column) {
      if (!is.numeric(final_df[[col]])) {
        final_df[[col]] <- as.numeric(final_df[[col]])
      }
    }
  }
  
  #Anything not in percentile form, convert to percentile by dividing columns by their max value
  for (col in (colnames(final_df))) {
    if (col != id_column) {
      if (!all(final_df[[col]] >= 0 & final_df[[col]] <= 1)) {
        final_df[[col]] <- final_df[[col]]/max(final_df[[col]])
      }
    }
  }
  
}