

#county to tract
ct_tr_population <- read.csv("scripts/utility_function/weights_data/2020ct_tr.csv", header = T)[-1,] 
ct_tr_area <- read.csv("scripts/utility_function/weights_data/2020ct_tr_area.csv", header = T)[-1,] 



process_data <- function(data) {
  library(dplyr)
  data$tract <- gsub("\\.", "", data$tract)
  processed_data <- data %>%
    mutate(afact = as.numeric(afact)) %>%
    mutate(tract.census.geoid = paste0(county, tract)) %>%
    rename(county.census.geoid = county) %>%
    select(county.census.geoid, afact, tract.census.geoid)
  
  return(processed_data)
}

ct_tr_area <- process_data(ct_tr_area) 
ct_tr_population <- process_data(ct_tr_population)



county_tract <- function(data, weight_type, variable, weight, calc_method){
   if (!is.data.frame(data)) {
    stop("Input 'data' must be a dataframe.")
  }
  
  if (weight_type == "population") {
    data <- data %>%
      left_join(ct_tr_population, by = "tract.census.geoid")
  }
  if (weight_type == "area") {
    data <- data %>%
      left_join(ct_tr_area, by = "tract.census.geoid")
  }
  if (tolower(calc_method) == "weighted_mean") {
    processed_data <- data %>%
      group_by(tract.census.geoid) %>%
      mutate(!!paste0(variable, "_weighted") := weighted.mean(!!sym(variable), !!sym(weight), na.rm = TRUE))
  } 
  else if (tolower(calc_method) == "weighted_sum") {
    processed_data <- data %>%
      group_by(tract.census.geoid) %>%
      mutate(!!paste0(variable, "_sum") := sum(!!sym(variable) * !!sym(weight), na.rm = TRUE))
  } 
  else if (tolower(calc_method) == "sum") {
    processed_data <- data %>%
      group_by(tract.census.geoid) %>%
      mutate(!!paste0(variable, "_sum") := sum(!!sym(variable), na.rm = TRUE))
  } 
  
  else {
    stop("Invalid value for 'calc_method'. Please specify either 'weighted_mean', 'weighted_sum', or 'sum'.")
  }
  
  return(processed_data)
  
}