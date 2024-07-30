crosswalk_geom <- function(data, target, location_columns = NULL, extensive = FALSE, join_method = NULL) {
    #' crosswalk_geom function
    #' @description
    #' Perform spatial crosswalks on point, shapefile, and raster data when a geo-id crosswalk is unavailable. 
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
  
  if (length(location_columns) == 2) {
    
    # Convert the dataframe to a spatial object using the target's CRS
    points <- st_as_sf(data, coords = location_columns, crs = st_crs(target))
    
    # Perform the spatial join to find the containing shape for each point
    joined <- st_join(points, target, join = st_contains)
    
    } else if (method == "max_area") {
      # Ensure data is a spatial object and has the same CRS as the target
      data <- st_transform(data, crs = st_crs(target))
      data <- st_make_valid(data)
      
      # Perform the spatial join for assigning source values to target polygons with the maximum area coverage of the source polygons
      joined <- st_join(data, target, join = st_intersects, largest = TRUE)
      
      
      } else if (method == "areal_weighted") {
        # Ensure data is a spatial object and has the same CRS as the target
        data <- st_transform(data, crs = st_crs(target))
        data <- st_make_valid(data)
        # Perform the spatial join using areal aggregation extensive = TRUE (spatially extensive, e.g population) or extensive = FALSE (spatially intensive, e.g population density) 
        joined <- st_interpolate_aw(data, target, extensive = extensive)
  }
  
  return(joined)
}
