crosswalk_geom <- function(shapefile, data) {
  
  # Use case: Assign point data or smaller polygons to the target scale based on the larger polygons they are        # contained in. Uses st_contains to check if shape contained by another.
  
  # Args: 
  # shapefile: shapefile containing polygons
  # data: shapefile containing polygons OR data with latitude and longitude columns (can be converted to sf)
  # source_scale: a list. the column name(s) of the source scale e.g c("latitude", "longitude") or c("geometry")
  # target_scale: the name (str) of the target column name e.g ("geometry")
  
  # Output: 
  # One joined dataset on the target scale
  
  require(sf)
  # Transform data to the CRS of the target polygons
  
  if (st_crs(data_sf) != st_crs(shapefile)) {
    stop("CRS of data and shapefile do not match even after transformation.")
  }
  
  # Perform the spatial join to check containment
  joined_data <- st_join(data_sf, shapefile, largest = TRUE)
  
  
  # Return the joined dataset
  return(joined_data)
}