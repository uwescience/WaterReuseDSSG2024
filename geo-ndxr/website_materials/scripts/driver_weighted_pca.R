# these are dependencies to run locally - modify with prefix from your config file. When running
# in WebR, these import statement is redundant
# library(rjson)
# # source("DSSG/WaterReuseDSSG2024/code/create_index/get_pca_weights.R")
# 


# figure out how many drivers are activated by the user selection
infer_active_drivers <- function(user_selection, base_structure) {
  
  # return set of drivers that have an indicator in the user selection
  active_drivers <- unique(
    base_structure[base_structure$Indicator %in% user_selection, ]$Driver
  )
  
  return(active_drivers)
}

percentile_rank <- function(x) {
  rank(x, ties.method = "min") / length(x) * 100
}


get_percentiles <- function(df, id_column=NULL) {
  
  if (!is.null(id_column)) {
    numeric_df <- df %>% select(-all_of(c(id_column)))
  }
  
  else { 
    numeric_df <- df
  }
  
  df_percentiles <- as.data.frame(lapply(numeric_df, percentile_rank))
  
  if (!is.null(id_column)) {
    df_out <- cbind(df[[id_column]], df_percentiles) %>% rename(!!sym(id_column) := `df[[id_column]]`)
  }
  
  else {
    df_out <- df_percentiles
  }
  
  return(df_out)
  
}

lin_scale <- function(x, min_val=0, max_val=1) {
  
  new_x <- x - min(x)
  unit_norm <- new_x/max(new_x)
  transformed_x <- (min_val + (max_val-min_val)*unit_norm)
  
  return(transformed_x)
  
}

multidriver_pca <- function(data, user_selection, 
                            index_structure, 
                            driver_weights="equal",
                            id_column = "id",
                            index_min = 0,
                            index_max = 100) {
  
  # first, figure out which drivers we are doing pca over
  active_drivers <- infer_active_drivers(user_selection, 
                                         base_structure = index_structure)


  driver_scores <- data.frame(matrix(ncol=0, nrow=nrow(data)))
  
  output_list <- list()

  for (i in 1:length(active_drivers)) {
    
    driver_slice <- index_structure[(index_structure[1] == active_drivers[i] & index_structure[,2] %in% user_selection),]

    indicators_for_driver_score <- driver_slice$Indicator
    
    if (length(indicators_for_driver_score) > 1) {
      print(paste("Running PCA on driver", active_drivers[i], "to reduce dimensionality to 1 number..."))
      data_for_pca <- data %>% select(all_of(indicators_for_driver_score))
      
      pca_result <- prcomp(data_for_pca, center = TRUE, scale. = TRUE)
      
      pca_scores <- as.data.frame(pca_result$x)$PC1
      
      driver_scores[[active_drivers[i]]] <- pca_scores
    }
    
    else {
      print("Encountered driver with single indicator, no PCA needed.")
      data_for_score <- data[,indicators_for_driver_score]
      driver_scores[[active_drivers[i]]] <- data_for_score
    }
  }
  
  normalized_driver_scores <- get_percentiles(driver_scores)
  
  # if driver weights are set to equal, return the average of each driver score
  if (driver_weights == "equal") {
    num_active_drivers <- ncol(normalized_driver_scores)
    weight_vector <- rep(1/num_active_drivers, num_active_drivers)
    weighted_avg_score <- as.matrix(normalized_driver_scores) %*% weight_vector
  }
  
  # else, take in user-inputted vector of weights and return score
  else {
    weighted_avg_score <- as.matrix(normalized_driver_score) %*% driver_weights
  }
  
  scaled_index <- lin_scale(weighted_avg_score, min_val = index_min, max_val = index_max)
  return(scaled_index)
}

