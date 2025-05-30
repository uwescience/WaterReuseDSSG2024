crosswalk_id <- function(data,
                         data2 = NULL,
                         source_scale, 
                         key) {
  #' Append a list of geospatial index columns
  #' @description
  #' 'crosswalk_id' returns dataframe with geo-spatial labels appended
  #' @param data (dataframe) raw data that needs to be converted to a different scale
  #' @param source_scale (Character) column that contains scale information. 
  #' ex) "FIPS Code", "Zipcode"
  #' @param key (Character) one of the formal names that correspond to the source_scale. 
  #' User should identify which of these names their source_scale match.
  #' For example, if the source_scale is "FIPS Code," - which is census tract code, user should specify "tract.census.geoid"
  #' List of options are:
  #'    "tract.census.geoid"              
  #'    "county.census.geoid"       
  #'    "puma.census.geoid"         
  #'    "state.census.geoid"          
  #'    "state.census.name" 
  #'    "metro.census.cbsa10.geoid" 
  #'    "metro.census.cbsa10.name"  
  #'    "metro.census.csa10.geoid" 
  #'    "metro.census.csa10.name"   
  #'    "region.woodard.nation"     
  #'    "region.woodard.culture"    
  #'    "region.census.main"      
  #'    "region.census.division"  
  #'
  #' @example
  #' drought_intermediary <- crosswalk_id(drought, 
  #'                         source_scale = "county_fips", 
  #'                         key = "county.census.geoid")
  #' @example
  #' User provides their own reference table. As a default, we provide census geoids as a reference table. 
  #' If the user wants to append reference table of other types, specify the data in the data2 argument. 
  #' processed_data <- crosswalk_id(data=df1, 
  #'                  data2=reference_table, 
  #'                  source_scale = "huc_id",
  #'                  key = "huc_id")
  
  
  library(readxl)
  library(tidycensus)
  library(tigris)
  options(tigris_use_cache = TRUE)
  library(tidyverse)
  library(data.table)
  library(dplyr)
  library(docstring)
  
  if (!is.null(data2)) {
    merged_data <- data %>%
      left_join(data2, by = setNames(key, source_scale))
    return(merged_data)
  } else {
    root_dir <- config::get("home_path")
    crosswalk_file <- readr::read_csv(paste0(root_dir,"/code/crosswalk/weights_data/census_reference_table.csv")) 
    crosswalk_file <- crosswalk_file[, -1]
    
    if (!is.character(data[[source_scale]])) {
      data <- data %>%
        mutate(!!sym(source_scale) := as.character(!!sym(source_scale)))
    }
    
    if (!key %in% names(crosswalk_file)) {
      stop("Key value is invalid. It has to be one of the valid column names in the reference table.")
    }
    
    merged_data <- data %>%
      left_join(crosswalk_file, by = setNames(key, source_scale), keep = TRUE)
    
    return(merged_data)
  }
}
