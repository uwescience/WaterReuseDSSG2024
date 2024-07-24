check_normalize_data <- function(final_df, location_columns) {
  # Diagnostic to determine number of NAs
  # Could also map where there is missing data??
  # Check all data types are numeric / can be converted to numeric 
  # location_columns are shapes??
  # normalize data 
  require(naniar)
  require(BBmisc)
  require(dplyr)
  
  #print a plot of number of missing observations per variable
  print(gg_miss_var(final_df))
  
  #pipeline to convert columns to numeric type
  final_df_no_locations <- final_df %>% 
    dplyr::select(-any_of(location_columns))
  
  for (col in (colnames(final_df_no_locations))) {
    if (!is.numeric(final_df_no_locations[[col]])) {
      final_df_no_locations[[col]] <- as.numeric(final_df_no_locations[[col]])
    }
  }
  
  #normalize all non-location columns 
  final_df_normalized <- normalize(final_df_no_locations)
  
  #select out location columns from original df
  location_df <- final_df %>%
    select(all_of(location_columns))
  
  #add back location columns to normalized df
  final_df_combined_normalized <- bind_cols(location_df, final_df_normalized)
  
  return(final_df_combined_normalized)
}