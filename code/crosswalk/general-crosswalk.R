
setwd(config::get("home_path"))

source("code/crosswalk/crosswalks_id.R")
source("code/crosswalk/county_tract_weight.R")
source("code/crosswalk/tract_county_weight.R")


crosswalk <- function(data, 
                      data_type = NULL,
                      data2 = NULL,
                      shapefile = NULL, 
                      raster = NULL,
                      source_scale = NULL, 
                      key = NULL, 
                      method = NULL, 
                      variable = NULL,
                      weight_variable = NULL,
                      calc_method = NULL,
                      output_type = NULL
                      ) {

    #' @description Perform spatial or dataset crosswalk operations based on provided parameters.
    #'   
    #'   @param data: Data source to be crosswalked. Can be labeled data with ID location column(s), 
    #'        point data (containing lat/lon columns), a shapefile, or a raster.
    #'   @param data_type: Type of 'data'. Options include "points" (lat/lon data), "shapes" (shapefile),
    #'              or "raster" (raster data). Default is NULL.
    #'   @param data2: Additional data source containing the same key as 'data'. Only applicable if 'key' argument is not NULL.
    #'   @param shapefile: Shapefile containing target geometries to be combined with 'data' (no key required).
    #'   @param raster: Raster data to be combined with 'data' (no key required).
    #'   @param source_scale: Name(s) of location column(s) in the original data. Should be a list if multiple columns.
    #'   @param key: Key identifier for crosswalking to a new census data scale or between datasets. 
    #'        Should be sourced from a list of column names from 'data/crosswalk_file' or 'data2'.
    #'   @param method: Method for aggregation if 'data' is being crosswalked to another scale or dataset. 
    #'           Options: "area" or "population". Defaults to area prioritization.
    #'   @param variable: List of variable(s) in 'data' that require weighting or aggregation.
    #'   @param weight_variable: Variable used as weight in aggregation calculations.
    #'   @param calc_method: Method for aggregation and apportioning within 'data'. 
    #'                Options: "sum", "weighted_sum", or "weighted_mean".
    #'   @param output_type: Relevant when 'raster' is not NULL. Options: "raster" or "shapefile" for output format.
    #'
    #' @Output:
    #'   Returns a dataframe on the target geographic scale after performing the crosswalk operation.
    #'
    #' @Details:
    #'   - If 'key' is provided, performs ID-based crosswalk using 'crosswalk_id'.
    #'   - If 'shapefile' and 'data' are provided (and 'key' is NULL), performs geometric crosswalk using 'crosswalk_geom'.
    #'   - If 'raster' and 'data' are provided, performs raster-based crosswalk using 'crosswalk_raster'.
    #'   - If 'method', 'variable', 'weight_variable', and 'calc_method' are provided, performs tract to county aggregation using 'tract_county'.
    #'   - If 'method', 'variable', 'weight_variable', and 'calc_method' are provided, performs county to tract aggregation using 'county_tract'.
    #'
    #' @Notes:
    #'   - The function requires at least one non-null argument ('data', 'shapefile', or 'raster') to perform crosswalk operations.
    #'
    
  if (!is.null(key)) {
    
    crosswalk_id(data = data,
                   source_scale = source_scale,
                   key = key)
  }
  
  else if (!is.null(shapefile) && !is.null(data) && is.null(key)) {
    
    crosswalk_geom(shapefile = shapefile, 
                   data = data, 
                   location_columns = source_scale,
                   type = data_type)
  }
  
  else if (!is.null(raster)) {
    
    crosswalk_raster(data1 = raster, 
                     data2 = data, 
                     method = method, 
                     output_type = output_type, 
                     points = data_type)
  }
  
  else if (!is.null(weight_type) && !is.null(variable) && !is.null(calc_method)) {
    if (is.null(source_scale) | is.null(key)) {
      tract_county(data = data, 
                   weight_type = method,
                   variable = variable,
                   weight = weight, 
                   calc_method = calc_method)
      
    }
    else (!is.null(source_scale) && !is.null(key)) {
      data_id <- crosswalk_id(data = data,
                              source_scale = source_scale,
                              key = key)
      
      tract_county(data = data_id, 
                   weight_type = method,
                   variable = variable,
                   weight = weight, 
                   calc_method = calc_method)
    }
    
  }
  
  else if (!is.null(weight_type) && !is.null(variable) && !is.null(calc_method)) {
    data_id <- crosswalk_id(data = data,
                            source_scale = source_scale,
                            key = key)
    county_tract(data = data, 
                 weight_type = method,
                 variable = variable,
                 weight = weight, 
                 calc_method = calc_method)
    
  }
  
  else {
    stop("data and shapefile passed to the crosswalk() function are both null.\n
         At least one must be non-null")
  }
}