check_compatibility <- function(data, shapefile, data_key, shape_key) {
  
  # Two checks are needed:
  # - data_key is a column in data & shape_key is a column in shapefile
  # - data_key and shape_key have the same type
  
  check_result <- data_key %in% names(data) && 
    shape_key %in% names(shapefile) && 
    type(data_key) == typeof(shape_key)
}