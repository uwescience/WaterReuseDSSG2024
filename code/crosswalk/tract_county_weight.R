
tr_ct_population <- read.csv("scripts/utility_function/weights_data/2020tr_ct.csv", header = T)[-1,]
tr_ct_area <- read.csv("scripts/utility_function/weights_data/2020tr_ct_area.csv", header = T)[-1,]

library(dplyr)

process_data <- function(data) {
  data$tract <- gsub("\\.", "", data$tract)
  processed_data <- data %>%
    mutate(afact = as.numeric(afact)) %>%
    mutate(tract.census.geoid = paste0(county, tract)) %>%
    rename(county.census.geoid = county) %>%
    select(county.census.geoid, afact, tract.census.geoid)
  
  return(processed_data)
}

tr_ct_population <- process_data(tr_ct_population)
tr_ct_area <- process_data(tr_ct_area)

tract_county <- function(data, weight_type, variable, weight, calc_method) {
  if (is.data.frame(data)) {
    data <- data %>%
      select( "tract.census.geoid", {{ variable }})
  }
  if (!is.data.frame(data)) {
    stop("Input 'data' must be a dataframe.")
  }
  
  if (weight_type == "population") {
    data <- data %>%
      left_join(tr_ct_population, by = "tract.census.geoid")
  } else if (weight_type == "area") {
    data <- data %>%
      left_join(tr_ct_area, by = "tract.census.geoid")
  } else {
    stop("Invalid value for 'weight_type'. Please specify either 'population' or 'area'.")
  }
  
  print(head(data))
  
  if (tolower(calc_method) == "weighted_mean") {
    processed_data <- data %>%
      group_by(county.census.geoid) %>%
      summarize(!!paste0(variable, "_weighted") := weighted.mean(!!sym(variable), !!sym(weight), na.rm = TRUE))
  } else if (tolower(calc_method) == "weighted_sum") {
    processed_data <- data %>%
      group_by(county.census.geoid) %>%
      summarize(!!paste0(variable, "_sum") := sum(!!sym(variable) * !!sym(weight), na.rm = TRUE))
  } else if (tolower(calc_method) == "sum") {
    processed_data <- data %>%
      group_by(county.census.geoid) %>%
      summarize(!!paste0(variable, "_sum") := sum(!!sym(variable), na.rm = TRUE))
  } else {
    stop("Invalid value for 'calc_method'. Please specify either 'weighted_mean', 'weighted_sum', or 'sum'.")
  }
  
  return(processed_data)
}