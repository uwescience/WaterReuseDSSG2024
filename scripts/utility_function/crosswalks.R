
crosswalk_data <- function(data, 
                           source_scale, 
                           key, 
                           target_scale) {
  # args: key is the common column that helps join. target_scale has to be specified by the user. 
        # Both key and target_scale should be from the list of crosswalk_file.

  # output:data set that contains new column of target scale.
          library(readxl)
          library(tidycensus)
          library(tidyverse)
          library(raster)
          library(sf)
          
  tracts_url <- "https://nccsdata.s3.us-east-1.amazonaws.com/geo/xwalk/TRACTX.csv"
  crosswalk_file <- readr::read_csv(tracts_url)
  print(names(crosswalk_file))
  
  if (!is.character(data[(source_scale)])) {
    data <- data %>%
      dplyr::mutate({{ source_scale }} := as.character({{ source_scale }}))
  }
  
  print(paste0("Maximum number of digits for the identifier is ", max(nchar(source_scale))))
  print(paste0("Minimum number of digits for the identifier is ", min(nchar(source_scale))))
  
  appendix <- crosswalk_file %>%
    dplyr::select({{ key }}, {{ target_scale }}) 
  
  target_data <- data %>%
    dplyr::left_join(appendix, 
                     by = setNames(key, source_scale))
  
  return(target_data)
}
