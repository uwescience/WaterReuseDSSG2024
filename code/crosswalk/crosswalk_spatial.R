# setwd(config::get("home_path"))

source(paste0(root_dir, "/code/crosswalk/crosswalk_geom.R"))
source(paste0(root_dir,"/code/crosswalk/crosswalk_raster.R"))


crosswalk_spatial <- function(data, target, location_columns = NULL, extensive = FALSE, join_method = NULL) {
  
  #' crosswalk_spatial
  #' @description
  #' Perform spatial crosswalks on point, shapefile, and raster data when a geo-id crosswalk is unavailable. 
  #' 
  #' @param data: data on the source geographic scale. Can be a shapefile, raster, or in the case of point data, a table with lat/lon columns. 
  #' point data (lat, lon) or a shapefile containing shapes (polygons, lines, etc.). For point data crosswalking to a target polygon geometry, data is maintained on the point scale and assigned to a geometry (requires users to perform aggregation of choice outside the function
  #' @param target: shapefile containing shapes (polygons, lines, etc.). This is for the target boundaries/geographic levels. 
  #' @param location_columns: only required for points (e.g ("LONGITUDE", "LATITUDE") or c("lon", "lat"), longitude first and latitude second). Not required for shapefile or raster data. 
  #' @param extensive: TRUE if data of interest is spatially extensive, (e.g population, function = SUM) or FALSE if spatially intensive (e.g population density, function = MEAN). 
  #' @param join_method: in the case of shapefile to shapefile (multipoint and polygons, not points) crosswalks, choose "max_area" 
  #'                    or "areal_weighted" to inherit values of source data based on maximum intersection assignment or a area-weighted average/sum
  #'                    of all intersecting polygons. NULL in other cases.   
  #' @output 
  #' Returns a shapefile on the target scale (except raster/raster combinations, which output a stacked raster). Please check that your data is correctly aggregated and adjust input parameters as needed. 
  #' @Notes
  #' Relies on functions crosswalk_geom.R (data, target, location_columns, extensive, join_method) and crosswalk_raster.R (data, target, location_columns, extensive). 
  #' 
  #' This function will automatically detect geometry columns associated with shapefiles. 
  #' 
  #' Please be mindful of NA values prior to performing spatial crosswalks/joins. When taking areal-weighted averages and sums, all target geometries will be maintained even
  #'  if the resulting interpolation is NA. Prior to calculating the interpolation, NA values in the source data will be removed so as to not cause calculations to return NA. You will need to check your NAs and handle them in the way you see appropriate before using the crosswalked data output by this function.  
  #'  
  #' When assigning points to shapes, all points will be returned with their associated shapes (left join where points are maintained). When assigning point values to a raster, you will end up with a polygonized raster with appended values for points contained by the raster squares.
  #' 
  #'  
  #' Notes on using raster data in combination with other data: 
  #'  Point data is set on the raster scale but maintains its original values. NA values for polygonized rasters not containing a point. Will double count polygons containing multiple points. 
  #'  Raster/shapefile combinations will output a shapefile, not a raster. User must rasterize polygon data if they want the output to be a raster. 
  #'  Raster/raster combinations stack the two files to be a stacked raster object. The output is a stacked raster. Users must combine with another shapefile if they want a shapefile output. 
  #' @export
  
  require(sf)
  require(raster)
  require(dplyr)
  require(exactextractr)
  
  if (inherits(data, "SpatRaster") | inherits(target, "SpatRaster")) {
    return (crosswalk_raster(data, target, location_columns, extensive, join_method))
  }
  else {
    return (crosswalk_geom(data, target, location_columns, extensive, join_method))
  }
}