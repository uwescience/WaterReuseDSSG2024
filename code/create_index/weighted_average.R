get_weighted_average <- function(df,
                                   weights,
                                   excluded_cols) {
  
  data_matrix <- df %>% as.data.frame() %>% select(-all_of(excluded_cols))
  M <- as.matrix(data_matrix)
  
  print(typeof(M))
  print(typeof(weights))
  
  #return(M %*% weights)
}

