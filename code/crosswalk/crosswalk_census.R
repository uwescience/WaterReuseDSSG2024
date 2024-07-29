source("code/crosswalk/apply_weight.R")

# Read data files
ct_tr_population <- read.csv("./code/crosswalk/weights_data/2020ct_tr.csv", header = TRUE)[-1,] 
ct_tr_area <- read.csv("./code/crosswalk/weights_data/2020ct_tr_area.csv", header = TRUE)[-1,] 
tr_ct_population <- read.csv("./data/2020tr_ct.csv", header = TRUE)[-1,]
tr_ct_area <- read.csv("./data/2020tr_ct_area.csv", header = TRUE)[-1,]

zc_tr_population <- read.csv("./code/crosswalk/weights_data/2020zc_tr.csv", header = TRUE)[-1,] 
zc_tr_area <- read.csv("./code/crosswalk/weights_data/2020zc_tr_area.csv", header = TRUE)[-1,] 
tr_zc_population <- read.csv("./code/crosswalk/weights_data/2020tr_zc_area.csv", header = TRUE)[-1,] 
tr_zc_area <- read.csv("./code/crosswalk/weights_data/2020tr_zc_area.csv", header = TRUE)[-1,] 

pm_tr_population <- read.csv("./code/crosswalk/weights_data/2020pm_tr.csv", header = TRUE)[-1,] 
pm_tr_area <- read.csv("./code/crosswalk/weights_data/2020pm_tr_area.csv", header = TRUE)[-1,] 
tr_pm_population <- read.csv("./code/crosswalk/weights_data/2020tr_pm.csv", header = TRUE)[-1,]
tr_pm_area <- read.csv("./code/crosswalk/weights_data/2020tr_pm_area.csv", header = TRUE)[-1,]



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

# Crosswalk census function
crosswalk_census <- function(data, 
                             source_scale,
                             target_scale,
                             weight_by, 
                             method,
                             variable) {
  #' @param data dataframe input
  #' @param source_scale character vector. should be one from the list. 
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
  #' crosswalk_census(cvi, 
  #'          source_scale = "tract.census.geoid", 
  #'          target_scale = "county.census.geoid", 
  #'          weight_by = "population", 
  #'          method = "mean", 
  #'          variable = "CVI_overall")
  #'          
  #'          
  #'          
  #'          
    if (!is.data.frame(data)) {
    stop("Input 'data' must be a dataframe.")
  }
  
  if (source_scale == "county.census.geoid" && target_scale == "tract.census.geoid") {
    if (weight_by == "population") {
      processed_data <- apply_weight(data = data,
                                   method = method,
                                   source_scale = source_scale,
                                   weight_data = ct_tr_population, 
                                   key = "county.census.geoid",
                                   target_scale = "tract.census.geoid",
                                   variable = variable,
                                   weight_value = "afact")
    } else if (weight_by == "area") {
      processed_data <- apply_weight(data = data,
                                   method = method,
                                   source_scale = source_scale,
                                   weight_data = ct_tr_area, 
                                   key = "county.census.geoid",
                                   target_scale = "tract.census.geoid",
                                   variable = variable,
                                   weight_value = "afact")
    }
  } else if (source_scale == "tract.census.geoid" && target_scale == "county.census.geoid") {
    if (weight_by == "population") {
      processed_data <- apply_weight(data = data,
                                   method = method,
                                   source_scale = source_scale,
                                   weight_data = tr_ct_population, 
                                   key = "tract.census.geoid",
                                   target_scale = "county.census.geoid",
                                   variable = variable,
                                   weight_value = "afact")
    } else if (weight_by == "area") {
      processed_data <- apply_weight(data = data,
                                   method = method,
                                   source_scale = source_scale,
                                   weight_data = tr_ct_population, 
                                   key = "tract.census.geoid",
                                   target_scale = "county.census.geoid",
                                   variable = variable,
                                   weight_value = "afact")
    }
  } else if (source_scale == "puma.census.geoid" && target_scale == "tract.census.geoid") {
    if (weight_by == "population") {
      processed_data <- apply_weight(data = data,
                                   method = method,
                                   source_scale = source_scale,
                                   weight_data = pm_tr_population, 
                                   key = "puma.census.geoid",
                                   target_scale = "tract.census.geoid",
                                   variable = variable,
                                   weight_value = "afact")
    } else if (weight_by == "area") {
      processed_data <- apply_weight(data = data,
                                   method = method,
                                   source_scale = source_scale,
                                   weight_data = pm_tr_area, 
                                   key = "puma.census.geoid",
                                   target_scale = "tract.census.geoid",
                                   variable = variable,
                                   weight_value = "afact")
    }
  } else if (source_scale == "tract.census.geoid" && target_scale == "puma.census.geoid") {
    if (weight_by == "population") {
      processed_data <- apply_weight(data = data,
                                   method = method,
                                   source_scale = source_scale,
                                   weight_data = tr_pm_population, 
                                   key = "tract.census.geoid",
                                   target_scale = "puma.census.geoid",
                                   variable = variable,
                                   weight_value = "afact")
    } else if (weight_by == "area") {
      processed_data <- apply_weight(data = data,
                                   method = method,
                                   source_scale = source_scale,
                                   weight_data = tr_pm_area, 
                                   key = "tract.census.geoid",
                                   target_scale = "puma.census.geoid",
                                   variable = variable,
                                   weight_value = "afact")
    }
  } else {
    stop("Unsupported combination of source_scale, target_scale, and weight_by.")
  }
  
  
  return(processed_data)
}

