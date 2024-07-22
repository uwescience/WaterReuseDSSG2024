
crosswalk_id <- function(data,
                         data2,
                           source_scale, 
                           key) {
  library(readxl)
  library(tidycensus)
  library(tigris)
  options(tigris_use_cache = TRUE)
  library(tidyverse)
  library(data.table)
  library(dplyr)
  library(roxygen2)
  library(docstring)
  
  if (!is.null(data2)) {
    merged_data <- data %>%
      left_join(data, data2, by = setNames(key, source_scale))
    return(merged_data)
  }
  
  else{
  tracts_url <- "https://nccsdata.s3.us-east-1.amazonaws.com/geo/xwalk/TRACTX.csv"
  crosswalk_file <- readr::read_csv(tracts_url)
  
  
  if (!is.character(data[[source_scale]])) {
    data <- data %>%
      {{ source_scale }} <- {{ source_scale }}[1]
      mutate({{ source_scale }} := as.character({{ source_scale }}))
  }
  
  if (is.null(key)) {
    warning("Key value is invalid. It has to be one of the following character values.")
    print(unique(names(crosswalk_file)))
  }
  
  
  merged_data <- data %>%
    left_join(crosswalk_file, by = setNames(key, source_scale))
  
  if (!identical(source_scale, key)) {
    merged_data <- merged_data %>%
      rename({{ key }} := !!sym(source_scale))
  }
  
  return(merged_data)
  }
}
