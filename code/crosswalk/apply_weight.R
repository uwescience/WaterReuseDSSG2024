
apply_weight <- function(data, source_scale = NULL, 
                         weight_data = NULL, key = NULL, target_scale = NULL, 
                         variable = NULL,
                         method = NULL, weight_value = NULL) {
  library(dplyr)
  library(docstring)
  #' apply_weight
  #' @description This function will assign weights to the data frame. If weights are used to 
  #' @param data dataframe that contains the target scale
  #' @param weight_data dataframe that contains weights assigned to target scale
  #' @param source_scale character vector. name of the source_scale in data
  #' @param key character vector. name of the weight_data that matches with the source_scale in data
  #' @param target_scale character vector. source scale to convert into. target_scale should be available in the weight_data.
  #' @param weight_value character vector. name of the variable that contains weight values
  #' @param method aggregation or apportioning method. "weighted_mean", "weighted_sum", "sum", and "mean"
  #' @param variable variable of interest. can be a list of multiple variables
  #' @examples apply_weight( data = cvi, 
  #' weight_data = tr_zc_area, 
  #' source_scale = "FIPS Code", 
  #' key = "tract.census.geoid",
  #' target_scale = "county.census.geoid",
  #' weight_value = "afact",
  #' method = "weighted_sum",
  #' variable = c("CVI_overall", "CVI_base_all"))
  #' 

  
  if (!is.character(data[[source_scale]])) {
    data <- data %>%
      mutate({{ source_scale }} := as.character({{ source_scale }}))
  }
  
  joined_data <- data %>%
    left_join(weight_data, by = setNames(key, source_scale))
  print(names(joined_data))
  
  if (tolower(method) == "weighted_sum") {
    processed_data <- joined_data %>%
      group_by( {{ target_scale }} ) %>%
      mutate(across(all_of(variable), 
                    ~ sum(.x * 'weight_value', na.rm = TRUE),
                    .names = "{.col}_weighted.sum")) 
    
  } else if (tolower(method) == "weighted_mean") {
    processed_data <- joined_data %>%
      group_by({{ target_scale }} ) %>%
      mutate(length = count( {{ target_scale }}))
      mutate(across(all_of(variable), 
                    ~ (sum(.x * as.numeric(weight_value), na.rm = TRUE)/length),
                    .names = "{.col}_weighted.mean"))
    
  } else if (tolower(method) == "sum") {
    processed_data <- joined_data %>%
      group_by( {{ target_scale }} ) %>%
      mutate(across({{ variable }},  
                    ~ sum(., na.rm = TRUE),
                    .names = "{.col}_sum"))
    
  } else if (tolower(method) == "mean") {
    processed_data <- joined_data %>%
    group_by( {{ target_scale }} ) %>%
      mutate(across({{ variable }}, 
                    ~ mean(., na.rm = TRUE),
                    .names = "{.col}_mean"))
    
  } else {
    stop("Invalid value for 'method'. Please specify either 'weighted_mean', 'weighted_sum', 'mean', or 'sum'.")
  }
  
  return(processed_data)
}
docstring(apply_weight)

sample <- apply_weight(data = cvi, 
              weight_data = tr_ct_area, 
              source_scale = "FIPS Code", 
              key = "tract.census.geoid",
              target_scale = "county.census.geoid",
              weight_value = "afact",
              method = "weighted_mean",
              variable = c("CVI_overall", "CVI_base_all"))

