crosswalk_raster <- function(data1, data2, method = "area", output_type = NULL, points = FALSE) {
  #Args: 
    #data1: file of type raster
    #data2: point shapefile, polygon shapefile, or raster file
    #method: "area" or "population", informs how combination is done (avg vs. sum)
    #output_type: required only for raster/shapefile combination. Either "raster" or "shapefile"
    #points: default FALSE. Set to TRUE if data1 contains point data (lat, lon)
  #Output: 
    # Joined/combined dataframe from raster and other file
  
  # Function for Raster/Raster
  if (st_crs(data1) != st_crs(data2)) {
    data2 <- st_transform(data2, st_crs(data1))
  }
  
  combine_rasters <- function(raster1, raster2, method) {
    if (method == "area") {
      combined <- (raster1 + raster2) / 2  # Example: averaging the rasters
    } else if (method == "population") {
      combined <- raster1 + raster2  # Example: summing the rasters
    } else {
      stop("Invalid method for raster combination.")
    }
    return(combined)
  }
  
  # Function for Raster/Point
  raster_point_join <- function(raster, points) {
    point_values <- exact_extract(raster, points, fun = "mean", progress = FALSE)
    point_values <- unlist(point_values)
    point_values[is.na(point_values)] <- 0  # Handle NA values
    combined <- cbind(st_as_sf(points), raster_value = point_values)
    return(combined)
  }
  
  # Function for Raster/Shapefile
  raster_shapefile_join <- function(raster, shapefile, output_type) {
    if (output_type == "shapefile") {
      extracted_values <- exact_extract(raster, shapefile, "mean")  # Example: mean values
      shapefile$extracted_values <- extracted_values
      return(shapefile)
    } else if (output_type == "raster") {
      shapefile_rasterized <- rasterize(shapefile, raster)
      return(shapefile_rasterized)
    } else {
      stop("Invalid output type for raster/shapefile combination.")
    }
  }
  
  # Determine the types of input data and call the appropriate function
  if (inherits(data1, "Raster") && inherits(data2, "Raster")) {
    return(combine_rasters(data1, data2, method))
  } else if (inherits(data1, "Raster") && inherits(data2, "sf") && points == TRUE) {
    return(raster_point_join(data1, data2))
  } else if (inherits(data1, "Raster") && inherits(data2, "sf")) {
    return(raster_shapefile_join(data1, data2, output_type))
  } else {
    stop("Unsupported data types.")
  }
}