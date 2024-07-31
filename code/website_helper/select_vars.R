require(dplyr)

filter_data <- function(data,
                           cols_to_keep,
                           cols_to_ignore = c()) {
  
  #' Returns a subset of the variables in a dataframe
  #' 
  #' Enables recalculation of index on a subset of original variables
  #' 
  #' @param data the dataset from which the user wants to take a subset 
  #' of the original variables in order to recalculate the index
  #' 
  #' @param cols_to_keep a vector of 1/0 representing the columns that should 
  #' STAY in the filtered dataset AFTER the ignored columns are removed. 
  #' For example, if a dataset has columns 'geometry', 'var1', 'var2', 'var3'
  #' and the user wants to ignore 'geometry' (because it is non-numerical)
  #' and recalculate the index on 'var1' and 'var3' ONLY, the function would
  #' be called with `cols_to_keep = c(1,0,1)`
  #' 
  #' @param cols_to_ignore columns to disregard entirely. This is NOT the same
  #' as columns that should be DROPPED. Columns to disregard are non-numeric
  #' columns like `geometry` or an ID. Columns to DROP are numeric columns 
  #' that the user does not want to include in the filtered dataset / 
  #' recalculated index
  #' 
  #' The geometry column in a simple feature (sf) object is automatically
  #' disregarded and does not need to be specified in the argument
  
  num_data <- data %>% select(-c(cols_to_ignore))
  
  qual_data <- data %>% select(c(cols_to_ignore))
  
  filtered_data <- num_data %>% select(cols_to_keep)
  
  # using cbind makes this run much faster than using a spatial
  # join, but introduces a redundant geometry column,
  # which is dropped; spatial join would avoid this but run slower
  filtered_data <- cbind(qual_data, filtered_data)
  
  if ("geometry.1" %in% names(filtered_data)) {
    filtered_data <- filtered_data %>% select(-c("geometry.1"))
  }
  
  return(filtered_data)
  
}