check_id <- function(data, id_var) {
  
  #' Checks if the ID column is valid
  #' 
  #' Checks that the user-provided ID column is in the dataframe passed to create_index()
  #' 
  #' Inputs:
  #' 
  #'  - data (dataframe) - dataframe the user wants to create a toxpiR index from
  #'  - id_var (string) - name of the column in data that identifies the basic unit over which
  #'    the index is contstructed; for example, in an index of drought risk over US counties
  #'    the index might be 'county_id'
  #' 
  #' Output:
  #'    (boolean) - is the id valid (is it in the dataframe)?
    
  if (sum(id_var %in% names(data)) == 0) {
    stop("The id passed to create_index() has to be one of the columns in the dataset")
  }
}


check_indicators <- function(indicators) {
  
  #' Checks that indicators are numerics
  #' @description
    #' helper function to create_index; checks that all of the indicators that the
    #' user would like to turn into an index are numerics; otherwise converts them
  
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
  
  #' Creates an index with toxpiR
  #' 
  #' @description
    #' wrapper around toxpiR; takes a dataframe, weights, and a designated column specifying the id; 
    #' calculates a toxpiR index that is ready for mapping using the functions in map_utils
    #' 
  #' Inputs:
  #' - data (dataframe) - expects a dataframe containing a variable of
  #'   interest, indexed by a geographic region identifier like FIPS
  #'
  #' - shape (dataframe) - a shapefile that specifies the
  #'   geographic regions in question; must contain a 'geometry' column
  #'
  #' - data_key (string) - a string that contains the NAME of column in
  #'   data that should be used to merge it with the shapefile. This
  #'   should be something like "FIPS"
  #'
  #' - shape_key (string) - a string that contains the NAME of column in
  #'   the shapefile that should be used to merge it with the data. This
  #'   should be something like "FIPS"
  #'
  #' - variable (string) - a string containing the NAME of the column in
  #'   data that contains the variable that should be used to make the map
  #'
  #' - map_title (string) - the map title
  #'
  #' - map_caption (string) - a string defining the caption that appears
  #'   at the bottom right of the map figure
  #'
  #' - map_percentile (boolean) - whether the map should display raw values
  #'   of variable (=FALSE, default) or show which percentile of the
  #'   data distribution the geographic unit in question falls into (=TRUE)
  #'
  #' - low_color, high_color, na_color (strings) - the colors designating
  #'   the lowest and highest values of variable, respectively, and the
  #'   color that should indicate missing data
  #'
  #' - map_font (string) - font in the title, caption, legends
  #'
  #' Outputs:
  #' - a ggplot2 object mapping the shapes defined in the dataset and
  #'   color-coding them according to the value of variable; instead of
  #'   plotting the RAW value of variable, this function converts them
  #'   to percentile scores and maps the percentile scores
  
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