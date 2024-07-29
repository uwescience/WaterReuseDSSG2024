crosswalk_raster <- function(data, target, location_columns = NULL, extensive = FALSE) {
  require(raster)
  #' @description
  #' Perform spatial crosswalks on raster data and one of the following target types: raster or shapefile.    
  #' 
  #' @param data: point data (lat, lon) or a shapefile containing shapes (polygons, lines, etc.)
  #' @param target: shapefile containing shapes (polygons, lines, etc.). This is for the target boundaries/geographic levels (assumes larger than the starting level I think). 
  #' @param location_columns: required for points (e.g c("LATITUDE", "LONGITUDE") or c("lat", "lon") depending on data format), not required for shapefile data. 
  #' @param extensive: TRUE if data of interest is spatially extensive, (e.g population) or FALSE if spatially intensive (e.g population density) 
  #' @param join_method: in the case of shapefile to shapefile (multipoint and polygons, not points) crosswalks, choose "max_area" 
  #'                    or "areal-weighted" to inherit values of source data based on maximum intersection or a area-weighted average
  #'                    of all intersecting polygons. NULL in other cases, where the mean is taken by default.  
  
  #' @output 
  #' Returns a joined dataset on the target scale (a shapefile). 
  #' 
  #' @Notes
  #' Point data is maintained as points. User must rasterize resulting dataframe if they want the output of a point/raster join to be in raster form.
  #' Raster/shapefile combinations will output a shapefile, not a raster. User must rasterize polygon data if they want the output to be a raster. 
  #' Raster/raster combinations take the mosaic mean of the two files. The output is a raster. Users must combine with another shapefile if they want a shapefile output. 
  #' 
  
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