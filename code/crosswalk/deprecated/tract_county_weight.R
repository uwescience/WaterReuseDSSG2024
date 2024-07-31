
tr_ct_population <- read.csv("./data/2020tr_ct.csv", header = T)[-1,]
tr_ct_area <- read.csv("./data/2020tr_ct_area.csv", header = T)[-1,]



process_data <- function(data) {
  library(dplyr)
  library(purrr)
  data$tract <- gsub("\\.", "", data$tract)
  processed_data <- data %>%
    mutate(afact = as.numeric(afact)) %>%
    mutate(tract.census.geoid = paste0(county, tract)) %>%
    rename(county.census.geoid = county) %>%
    dplyr::select(county.census.geoid, afact, tract.census.geoid)
  
  return(processed_data)
}

tr_ct_population <- process_data(tr_ct_population)
tr_ct_area <- process_data(tr_ct_area)

tract_county <- function(data, weight_type, weight = "afact", calc_method) {
  if (!is.data.frame(data)) {
    stop("Input 'data' must be a dataframe.")
  }
  
  numeric_vars <- purrr::keep(data, is.numeric) %>% names()
  data <- data %>%
    select("tract.census.geoid", all_of(numeric_vars))
  
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
      summarize(across(all_of(numeric_vars), ~ weighted.mean(., !!sym(weight), na.rm = TRUE),
                       .names = "{.col}_weighted"))
  } else if (tolower(calc_method) == "weighted_sum") {
    processed_data <- data %>%
      group_by(county.census.geoid) %>%
      summarize(across(all_of(numeric_vars), ~ sum(., !!sym(weight), na.rm = TRUE),
                       .names = "{.col}_sum"))
  } else if (tolower(calc_method) == "sum") {
    processed_data <- data %>%
      group_by(county.census.geoid) %>%
      summarize(across(all_of(numeric_vars), ~ sum(., na.rm = TRUE),
                       .names = "{.col}_sum"))
  } else {
    stop("Invalid value for 'calc_method'. Please specify either 'weighted_mean', 'weighted_sum', or 'sum'.")
  }
  
  return(processed_data)
}