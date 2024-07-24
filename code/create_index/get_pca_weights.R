get_pca_weights <- function(data,
                            excluded_cols,
                            scale = TRUE,
                            verbose = FALSE) {
  
  ## TODO: checker function that verifies that all non-id columns are numeric
  
  # store the stuff that isn't the ID
  print(names(data))
  data_matrix <- data[ , !(names(data) %in% excluded_cols)]
  print(data_matrix)
  
  pca_result <- prcomp(data_matrix, scale.= TRUE)
  
  loadings <- data.frame(variable = names(pca_result$rotation[1, ]), 
             weight = pca_result$rotation[, 1])
  
  weights <- loadings$weight
  
  norm_weights <- abs(weights) / sum(abs(weights))
  
  return(norm_weights)
}