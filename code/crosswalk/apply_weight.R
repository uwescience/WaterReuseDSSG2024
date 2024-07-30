
apply_weight <- function(data, source_scale = NULL, 
                         weight_data = NULL, key = NULL, target_scale = NULL, 
                         variable = NULL,
                         method = NULL, weight_value = NULL) {
  #' apply_weight
  #' @description This function will assign weights to the data frame. 
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
    left_join(weight_data, by = setNames(key, source_scale), copy = TRUE)
  print(joined_data)
  processed_data <- joined_data %>%
    group_by(!!sym(target_scale)) %>%
    summarize(across(all_of(variable), 
                     ~ switch(method,
                              "weighted_sum" = sum(. * !!sym(weight_value), na.rm=TRUE),
                              "weighted_mean" = weighted.mean(., !!sym(weight_value), na.rm = TRUE),
                              "sum" = sum(., na.rm = TRUE),
                              "mean" = mean(., na.rm = TRUE),
                              stop("Invalid value for 'method'. Please specify either 'weighted_mean', 'weighted_sum', 'mean', or 'sum'.")
                     ),
                     .names = "{.col}_{tolower(method)}"))
  
  return(processed_data)
}

docstring(apply_weight)
sample <- apply_weight(data = cvi, 
              weight_data = tr_ct_area, 
              source_scale = "FIPS Code", 
              key = "tract.census.geoid",
              target_scale = "county.census.geoid",
              weight_value = "afact",
              method = "weighted_sum",
              variable = c("CVI_overall", "CVI_base_all"))

