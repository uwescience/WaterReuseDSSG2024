setwd(config::get("home_path"))

source("code/crosswalk/crosswalk_geom.R")
source("code/crosswalk/crosswalk_raster.R")


crosswalk_spatial <- function(data, target, location_columns = NULL, extensive = FALSE, join_method = NULL) {
  
  #' @description
  #' Perform spatial crosswalks on point, shapefile, and raster data when a geo-id crosswalk is unavailable. 
  #' 
  #' @param data: data on the source geographic scale. Can be a shapefile, raster, or in the case of point data, a table with lat/lon columns. 
  #' point data (lat, lon) or a shapefile containing shapes (polygons, lines, etc.)
  #' @param target: shapefile containing shapes (polygons, lines, etc.). This is for the target boundaries/geographic levels (assumes larger than the starting level I think). 
  #' @param location_columns: only required for points (e.g c("LATITUDE", "LONGITUDE") or c("lat", "lon") depending on data format), not required for shapefile or raster data. 
  #' @param extensive: TRUE if data of interest is spatially extensive, (e.g population) or FALSE if spatially intensive (e.g population density) 
  #' @param join_method: in the case of shapefile to shapefile (multipoint and polygons, not points) crosswalks, choose "max_area" 
  #'                    or "areal_weighted" to inherit values of source data based on maximum intersection or a area-weighted average
  #'                    of all intersecting polygons. NULL in other cases, where the mean is taken by default.  
  
  #' @output 
  #' Returns a joined dataset on the target scale (a shapefile, except in the case of raster/raster combinations, which returns a raster). 
  
  #' @Notes
  #' Relies on functions crosswalk_geom.R (data, target, location_columns, extensive, join_method) and crosswalk_raster.R (data, target, location_columns, extensive). 
  #' This function will automatically detect geometry columns associated with shapefiles. 
  #' Notes on using raster data in combination with other data: 
  #'  Point data is maintained as points. User must rasterize resulting dataframe if they want the output of a point/raster join to be in raster form.
  #'  Raster/shapefile combinations will output a shapefile, not a raster. User must rasterize polygon data if they want the output to be a raster. 
  #'  Raster/raster combinations take the mosaic mean of the two files. The output is a raster. Users must combine with another shapefile if they want a shapefile output. 
  #' 
  
  require(sf)
  require(raster)
  require(dplyr)
  require(exactextractr)
  
  if (inherits(data, "Raster") | inherits(target, "Raster")) {
    return (crosswalk_raster(data, target, location_columns, extensive))
  }
  else {
    return (crosswalk_geom(data, target, location_columns = NULL, extensive = FALSE, join_method = NULL))
  }
}