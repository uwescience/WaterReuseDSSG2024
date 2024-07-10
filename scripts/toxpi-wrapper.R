check_id <- function(data, id_var) {
  
  # Inputs:
  # - data (dataframe) - dataframe the user wants to create a toxpiR index from
  # - id_var (string) - name of the column in data that identifies the basic unit over which
    # the index is contstructed; for example, in an index of drought risk over US counties
    # the index might be 'county_id'
  
  # Output:
  # (boolean) - is the id valid (is it in the dataframe)?
  
  if (sum(id_var %in% names(data)) == 0) {
    stop("The id passed to create_index() has to be one of the columns in the dataset")
  }
}

# helper function to create_index; checks that all of the indicators that the
# user would like to turn into an index are numerics; otherwise converts them
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


# takes a dataframe, weights, and a designated column specifying the id; calculates a toxpiR index
# that is ready for mapping functions in map_utils
create_index <- function(df, id_col, weights, index_name = "index_value") {
  
  # Inputs:
  # - df (dataframe) - data containing a row identifier and a set of numeric variables
    # that should be incorporate into the index
  
  # - id_col (string) - name of the column in data that identifies the basic unit over which
    # the index is contstructed; for example, in an index of drought risk over US counties
    # the index might be 'county_id'
  
  # - weights (vector) - length should be (nrow(df) - 1). Specifies the weight that each component of
    # the index should receive when it is calculated by toxpi
  
  # index_name (string) - name of the index - this will become the name of the column containing the
    # index value in the output
  
  # Outputs:
  # - dataframe with 2 columns and N rows, where N is the number of rows in df. For each value of
    # the id, calculates index value and outputs it in a format that is easy for the mapper to deal with
  
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