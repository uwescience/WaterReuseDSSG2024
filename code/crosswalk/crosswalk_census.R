
# Crosswalk census function
crosswalk_census <- function(data, 
                             key,
                             source_scale,
                             target_scale,
                             weight_by, 
                             method,
                             variable) {
  #' 
  #' crosswalk across census tract, county, and puma
  #' @description crosswalk for census
  #' @param data dataframe input
  #' @param source_scale character vector. Column that identifies the unit of analysis in the data.
  #' @param key character vector. should be one from the list. 
  #'      "tract.census.geoid"
  #'      "county.census.geoid"
  #'      "puma.census.geoid"
  #' @param target_scale character vector. should be one from the list. 
  #'      "tract.census.geoid"
  #'      "county.census.geoid"
  #'      "puma.census.geoid"
  #' @param weight_by values to be weighted by. "population" or "area"
  #' @param method aggregation or apportioning method. "weighted_mean", "weighted_sum", "sum", and "mean"
  #' @param variable a list of variables that need to be transformed into a different scale
  #' @examples
  #' result <- crosswalk_census(data = cvi,
  #'           source_scale = "FIPS Code",
  #'             key = "tract.census.geoid",
  #'             target_scale = "county.census.geoid",
  #'             weight_by = "population",
  #'             method = "weighted_mean",
  #'             variable = c("CVI_overall", "CVI_base_all"))
  #'             print(result)
  #'          
  #'    
  #'    source("./code/crosswalk/apply_weight.R")
  
  # Read data files
  root_dir <- config::get()
  ct_tr_population <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020ct_tr.csv"), header = TRUE)[-1,] 
  ct_tr_area <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020ct_tr_area.csv"), header = TRUE)[-1,] 
  tr_ct_population <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020tr_ct.csv"), header = TRUE)[-1,]
  tr_ct_area <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020tr_ct_area.csv"), header = TRUE)[-1,]
  
  zc_tr_population <-read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020zc_tr.csv"), header = TRUE)[-1,] 
  zc_tr_area <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020zc_tr_area.csv"), header = TRUE)[-1,] 
  tr_zc_population <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020tr_zc_area.csv"), header = TRUE)[-1,] 
  tr_zc_area <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020tr_zc_area.csv"), header = TRUE)[-1,] 
  
  pm_tr_population <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020pm_tr.csv"), header = TRUE)[-1,] 
  pm_tr_area <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020pm_tr_area.csv"), header = TRUE)[-1,] 
  tr_pm_population <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020tr_pm.csv"), header = TRUE)[-1,]
  tr_pm_area <- read.csv(paste0(root_dir, "/code/crosswalk/weights_data/2020tr_pm_area.csv"), header = TRUE)[-1,]
  
  
  
  # Process data function
  process_data <- function(data) {
    library(dplyr)
    
    data$afact <- as.numeric(data$afact)
    
    if ("county" %in% names(data) && "tract" %in% names(data)) {
      data$tract <- gsub("\\.", "", data$tract)
      data <- data %>%
        mutate(tract.census.geoid = paste0(county, tract)) %>%
        rename(county.census.geoid = county) 
    } 
    
    if ("puma22" %in% names(data)) {
      data <- data %>%
        rename_with(~ifelse(. %in% "puma22", "puma.census.geoid", .),
                    .cols = "puma22")
    } 
    
    return(data) }
  
  
  # Apply processing
  ct_tr_area <- process_data(ct_tr_area) 
  ct_tr_population <- process_data(ct_tr_population)
  tr_ct_population <- process_data(tr_ct_population)
  tr_ct_area <- process_data(tr_ct_area)
  pm_tr_population <- process_data(pm_tr_population)
  pm_tr_area <- process_data(pm_tr_area)
  tr_pm_population <- process_data(tr_pm_population)
  tr_pm_area <- process_data(tr_pm_area)
  
  library(dplyr)
  if (!is.data.frame(data)) {
    stop("Input 'data' must be a dataframe.")
  }
  
  weight_data <- switch(paste(key, target_scale, weight_by, sep = "_"),
                        "county.census.geoid_tract.census.geoid_population" = ct_tr_population,
                        "county.census.geoid_tract.census.geoid_area" = ct_tr_area,
                        "tract.census.geoid_county.census.geoid_population" = tr_ct_population,
                        "tract.census.geoid_county.census.geoid_area" = tr_ct_area,
                        "puma.census.geoid_tract.census.geoid_population" = pm_tr_population,
                        "puma.census.geoid_tract.census.geoid_area" = pm_tr_area,
                        "tract.census.geoid_puma.census.geoid_population" = tr_pm_population,
                        "tract.census.geoid_puma.census.geoid_area" = tr_pm_area,
                        stop("Unsupported combination of source_scale, target_scale, and weight_by.")
  )
  
  processed_data <- apply_weight(data = data,
                                 method = method,
                                 weight_data = weight_data, 
                                 source_scale = source_scale,
                                 key = key,
                                 target_scale = target_scale,
                                 variable = variable,
                                 weight_value = "afact")
  
  return(processed_data)
}




