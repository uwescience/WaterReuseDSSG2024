
crosswalk_raster <- function(data, target, location_columns = NULL, extensive = FALSE) {
  #' @description
  #' Perform spatial crosswalks on raster data and one of the following target types: raster or shapefile.    
  #' 
  #' @param data: point data (lat, lon) or a shapefile containing shapes (polygons, lines, etc.)
  #' @param target: shapefile containing shapes (polygons, lines, etc.). This is for the target boundaries/geographic levels.
  #' @param location_columns: required for points (e.g c("LONGITUDE", "LATITUDE") or c("lon", "lat") longitude first, latitude second). Not required for shapefile data. 
  #' @param extensive: TRUE if data of interest is spatially extensive, (e.g population) or FALSE if spatially intensive (e.g population density).
  #' 
  #' @output 
  #' Returns a joined dataset on the target scale (a shapefile). 
  #' 
  #' @Notes
  #' The raster dataset needs to be read using the terra package
  #' Point data is maintained as points. User must rasterize resulting dataframe if they want the output of a point/raster join to be in raster form.
  #' Raster/shapefile combinations will output a shapefile, not a raster. User must rasterize polygon data if they want the output to be a raster. 
  #' Raster/raster combinations take the mosaic mean of the two files. The output is a raster. Users must combine with another shapefile if they want a shapefile output. 
  #' @export
  
  
  # Load the the dataset
  require(terra)
  require(sf)
  
  # Ensure CRS match between data and target
  if (!identical(crs(data), crs(target))) {
    target <- st_transform(target, crs(data))
  }
  
  # Function for Raster/Raster
  combine_rasters <- function(raster1, raster2) {
    # Preprocess rasters so that they share the same extent and resolution 
    raster2_resampled <- terra::resample(raster2, raster1)
    stacked_raster <- c(raster1, raster2_resampled)
    
    # Assign names to each layer
    names(stacked_raster) <- c("data_raster1", "target_raster2")
    
    return(stacked_raster)
  }
  
  # Function for Raster/Point
  raster_point_join <- function(points, raster, location_columns) {
    points <- st_as_sf(points, coords = location_columns, crs = crs(target))
    
    # Rasterize points
    rasterized_points <- terra::rasterize(points, raster)
    
    # Extract values from raster
    extracted_values <- terra::extract(raster, points)
    
    # Join extracted values back to points
    points_with_values <- cbind(st_drop_geometry(points), extracted_values)
    
    return(points_with_values)
  }
  
  # Function for Raster/Shapefile
  raster_shapefile_join <- function(raster, shapefile, extensive) {
    # Turn raster into polygons
    polygonized_raster <- as.polygons(raster)
    polygonized_raster <- st_as_sf(polygonized_raster)
    polygonized_raster <- st_transform(polygonized_raster, crs = st_crs(shapefile))
    
    # Perform areal interpolation
    interpolated_data <- st_interpolate_aw(polygonized_raster, shapefile, extensive = extensive)
    
    # Ensure matching rows and extract GEOID column
    interpolated_data$GEOID <- shapefile$GEOID[match(st_geometry(interpolated_data), st_geometry(shapefile))]
    
    return(interpolated_data)
  }
  
  # Determine the types of input data and call the appropriate function
  if (inherits(data, "SpatRaster") && inherits(target, "SpatRaster")) {
    return(combine_rasters(data, target))
  } else if (inherits(target, "SpatRaster") && !is.null(location_columns) && length(location_columns) == 2) {
    return(raster_point_join(data, target, location_columns))
  } else if (inherits(data, "SpatRaster") && inherits(target, "sf")) {
    return(raster_shapefile_join(data, target, extensive))
  } else {
    stop("Unsupported data types. Check inputs.")
  }
}
