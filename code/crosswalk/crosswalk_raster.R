crosswalk_raster <- function(data, target, location_columns = NULL, extensive = FALSE) {
  #' @description
  #' Perform spatial crosswalks on raster data and one of the following target types: raster or shapefile.    
  #' 
  #' @param data: point data (lat, lon) or a shapefile containing shapes (polygons, lines, etc.)
  #' @param target: shapefile containing shapes (polygons, lines, etc.). This is for the target boundaries/geographic levels (assumes larger than the starting level I think). 
  #' @param location_columns: required for points (e.g c("LONGITUDE", "LATITUDE") or c("lon", "lat") longitude first, latitude second). Not required for shapefile data. 
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
  #' @export
  
  
  # Function for Raster/Raster
  
  if (st_crs(data1) != st_crs(data2)) {
    data2 <- st_transform(data2, st_crs(data1))
  }
  
  combine_rasters <- function(raster1, raster2) {
    
    #preprocess rasters so that they share the same extent and resolution 
    raster2_resampled <- resample(raster2, raster1, method = "bilinear")
    extent(raster2_resampled) <- extent(raster1)
    
    stacked_raster <- stack(raster1, raster2_resampled)
    
    # Assign names to each layer
    names(stacked_raster) <- c("data_raster1", "target_raster2")
    
    return(stacked_raster)
  }
  
  # Function for Raster/Point
  raster_point_join <- function(points, raster, location_columns) {
    
    points <- st_as_sf(points, coords = location_columns, crs = st_crs(target))
    
    #turn raster in polygons, boxes and then do areal_weighted mean - st_make_grid 
    polygonized_raster <- rasterToPolygons(raster, n = 4)
    
    #transform in sf object
    polygonized_raster <- st_as_sf(polygonized_raster)
    polygonized_raster <- st_transform(data, crs = st_crs(shapefile))
    polygonized_raster <- st_make_valid(data)
    
    #calculate spatial join - potential issue
    joined_table <- st_join(polygonized_raster, points, join = st_contains, left = TRUE)
    
    return(joined_table)
  }
  
  # Function for Raster/Shapefile
  raster_shapefile_join <- function(raster, shapefile, extensive) {

        #turn raster in polygons, boxes and then do areal_weighted mean - st_make_grid 
        polygonized_raster <- rasterToPolygons(raster, n = 4)
        
        #transform in sf object
        polygonized_raster <- st_as_sf(polygonized_raster)
        polygonized_raster <- st_transform(data, crs = st_crs(shapefile))
        polygonized_raster <- st_make_valid(data)
        
        #take the areal-weighted mean/sum of the polygonized raster and shapefile polygons
        new_shapefile <- st_interpolate_aw(polygonized_raster, shapefile, extensive = extensive, na.rm = TRUE, keep_na = TRUE)
        return(new_shapefile)
      }
  
  # Determine the types of input data and call the appropriate function
  if (inherits(data, "Raster") && inherits(target, "Raster")) {
    return(combine_rasters(data, target))
  } else if (inherits(target, "Raster") && length(location_columns) == 2) {
    return(raster_point_join(data, target, location_columns))
  } else if (inherits(data, "Raster") && inherits(target, "sf")) {
    return(raster_shapefile_join(data, target, extensive))
  } else {
    stop("Unsupported data types. Check inputs.")
  }
}