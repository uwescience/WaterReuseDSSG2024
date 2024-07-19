crosswalk_geom <- function(data, shapefile, location_columns = NULL, type = "shapes") {
  
  # Args: 
    # data: point data (lat, lon) or a shapefile containing shapes (polygons, lines, etc.)
    # shapefile: shapefile containing shapes (polygons, lines, etc.). This is for the target boundaries/geographic levels (assumes larger than the starting level I think). 
    # location_columns: required for points (e.g c("LATITUDE", "LONGITUDE") or c("lat", "lon") depending on data format), not required for shapefile data. 
    # type: default is "shapes", input "points" otherwise. 
  # Output: 
    # A joined dataset (shapefile) containing the scales 
  
  if (type == "points" && !is.null(location_columns)) {
    
    # Convert the dataframe to a spatial object using the shapefile's CRS
    points <- st_as_sf(data, coords = location_columns, crs = st_crs(shapefile))
    
    # Perform the spatial join to find the containing shape for each point
    joined <- st_join(points, shapefile, join = st_within, left = TRUE)
    
  } else {
    # Ensure data is a spatial object and has the same CRS as the shapefile
    data <- st_transform(data, crs = st_crs(shapefile))
    data <- st_make_valid(data)
    
    # Perform the spatial join
    joined <- st_join(data, shapefile, join = st_contains, left = TRUE)
  }
  
  return(joined)
}
