crosswalk_raster <- function(data, target, location_columns = NULL, extensive = FALSE) {
  require(raster)
  #Args: 
    #data1: file of type raster
    #data2: point shapefile, polygon shapefile, or raster file
    #location_columns: 
    #extensive: extensive = TRUE (spatially extensive, e.g population) or 
                #extensive = FALSE (spatially intensive, e.g population density) 
  #Output: 
    # Joined/combined dataframe from raster and other file
  
  # Function for Raster/Raster
  if (st_crs(data1) != st_crs(data2)) {
    data2 <- st_transform(data2, st_crs(data1))
  }
  
  combine_rasters <- function(raster1, raster2, extensive) {
    if (extensive == FALSE) {
      combined = mosaic(raster1, raster2, fun = mean)
    } else if (extensive == TRUE) {
      combined = mosaic(raster1, raster2, fun = max)
    } 
    return(combined)
  }
  
  # Function for Raster/Point
  raster_point_join <- function(points, raster, location_columns) {
    points <- st_as_sf(points, coords = location_columns, crs = st_crs(target))
    point_values <- exact_extract(raster, points, fun = "mean", progress = FALSE)
    point_values <- unlist(point_values)
    point_values[is.na(point_values)] <- 0  # Handle NA values
    combined <- cbind(st_as_sf(points), raster_value = point_values)
    return(combined)
  }
  
  # Function for Raster/Shapefile
  raster_shapefile_join <- function(raster, shapefile) {
      if (extensive == FALSE) {
        extracted_values <- exact_extract(raster, shapefile, "mean")  # mean values preserve area
        shapefile$extracted_values <- extracted_values
        return(shapefile)
      }
    else {
      extracted_values <- exact_extract(raster, shapefile, "sum") # sum preserves population
      shapefile$extracted_values <- extracted_values
      return(shapefile)
    }
  }
  
  # Determine the types of input data and call the appropriate function
  if (inherits(data, "Raster") && inherits(target, "Raster")) {
    return(combine_rasters(data, target, extensive))
  } else if (inherits(target, "Raster") && length(location_columns) == 2) {
    return(raster_point_join(data, target, location_columns))
  } else if (inherits(data, "Raster") && inherits(target, "sf")) {
    return(raster_shapefile_join(data, target))
  } else {
    stop("Unsupported data types. Check inputs.")
  }
}