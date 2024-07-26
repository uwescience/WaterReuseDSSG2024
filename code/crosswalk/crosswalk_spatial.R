setwd(config::get("home_path"))

source("code/crosswalk/crosswalk_geom.R")
source("code/crosswalk/crosswalk_raster.R")


crosswalk_spatial <- function(data, target, location_columns = NULL, extensive = FALSE, join_method = NULL) {
  #Args: 
    #data: data on the source geographic scale. Can be a shapefile, raster, or in the case of point data, a table with lat/lon columns. 
    #target: data on the target geographic scale. Can be a shapefile or a raster. 
    #location_columns: in the case of tabular point data with lat/lon columns,
                      #please provde a list with the names of the columns, e.g c("LATITUDE", "LONGITUDE")
    #extensive: extensive = TRUE (spatially extensive, e.g population) or 
                #extensive = FALSE (spatially intensive, e.g population density) 
    #join_method: in the case of non-point shapefile to shapefile crosswalks, 
                  #choose "max_area" or "areal-weighted" to inherit values of source data based on 
                  #maximum intersection or a area-weighted average of all intersecting polygons
  #Output: 
    #A shapefile on the target scale in all cases except raster/raster combinations, which will produce a combined raster. 
  if (inherits(data, "Raster") | inherits(target, "Raster")) {
    return (crosswalk_raster(data, target, location_columns, extensive))
  }
  else {
    return (crosswalk_geom(data, target, location_columns = NULL, extensive = FALSE, join_method = NULL))
  }
}