check_id <- function(data, id_var) {
  if (sum(id_var %in% names(data)) == 0) {
    stop("The id passed to create_index() has to be one of the columns in the dataset")
  }
}

check_indicators <- function(indicators) {
  are_numerics <- (sum(sapply(indicators, is.numeric)) == ncol(indicators))
  
  if (are_numerics) {
    return (indicators)
  }
  
  else {
    indicators <- indicators %>% 
      mutate_if(~ !is.numeric(.), ~ as.numeric(as.character(.)))
    
    return (indicators)
    
  }
}


create_index <- function(df, id_col, weights, index_name = "index_value") {
  
  check_id(df, id_col)
  
  indicator_names <- df %>%
    select(-(id_col)) %>%
    names()
  
  indicators <- df %>%
    select(indicator_names)
  
  indicators <- check_indicators(indicators) 
  
  indicators <- indicators %>% 
    select(indicator_names)
  
  slices_list <- list()
  
  for (i in 1:length(indicators)) {
    slices_list[[indicator_names[i]]] <- TxpSlice(txpValueNames = indicator_names[[i]])
  }
  
  slices <- do.call(TxpSliceList, slices_list)
  
  model <- TxpModel(txpSlices = slices, 
                    txpWeights = weights)
  
  idx <- txpCalculateScores(model=model,
                               input=df,
                               id.var=id_col)
  
  scores_for_map <- idx@txpScores
  
  output <- data.frame(
    id = df[[id_col]],
    index_col = scores_for_map
  )
  
  colnames(output)[which(colnames(output) == "index_col")] <- index_name
  
  return (output)
  
}