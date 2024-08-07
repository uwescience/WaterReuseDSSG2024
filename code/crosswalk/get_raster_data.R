get_raster_data <- function(raster_data, shapefile, fun = sum){
  require(sf)
  require(terra)
  
  # Make the shapefile CRS the same as the raster CRS if they are different
  if (crs(raster_data) != crs(shapefile)){
    shapefile <- st_transform(shapefile, crs(raster_data))
  }
  
  # Initialize a list to store data
  data_list <- list()
  
  # Loop through the shapefile to get the values of each row
  for (i in 1:nrow(shapefile)) {
    # Get the current row
    row <- shapefile[i, ]
    
    # Extract data for the current row
    extracted_value <- extract(raster_data, row, fun = fun, na.rm = TRUE, ID = FALSE)
    
    # Create a data frame for the current row
    df <- data.frame(GEOID = row$GEOID, extracted_value = extracted_value)
      
      # Append the data frame to the list
      data_list[[i]] <- df
  }
  
  # Combine all data frames into one
  extracted_data <- do.call(rbind, data_list)
  
  return(extracted_data)
}
