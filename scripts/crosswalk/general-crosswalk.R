# Jihyeon's code

setwd(config::get("home_path"))

source("./map_utils/crosswalks.R")

# Nora's code

# source()

crosswalk <- function(data, 
                      data_type = NULL,
                      data2 = NULL,
                      shapefile = NULL, 
                      raster = NULL,
                      source_scale = NULL, 
                      target_scale = NULL,
                      key = NULL, 
                      method = "area", 
                      output_type = NULL
                      ) {
  # Args: 
    # data: can be labeled data with ID location column(s), point data (contains lat/lon columns), a shapefile, or a raster
    # data_type: type of "data." Pick one of these options: "points", "shapes", "raster".
    # data2: data containing the same key as data. ONLY applicable if key argument is not NULL. 
    # shapefile: a shapefile containing target geometries, to be combined with data (no key)
    # raster: a raster to be combined with data (no key)
    # source_scale: the location column name(s) of the orginal data. List type..? 
    # target_scale: the location column name(s) of the data to be crosswalked. List type..? 
    # key: a numeric key identifier for crosswalking to a new census data scale or between datasets. 
    # method: pick between "area" or "population" to preserve when doing aggregations on datasets. Default area prioritization. 
    # output_type: relevant if raster is not NULL. Options are "raster" or "shapefile" when doing raster/shapefile crosswalks. 
    # source_scale: if data contains points given by latitude and longitude, source scale must contain those column names c("lat", "lon")
  # Output: 
    # A dataframe on the target geographic scale. At this time, the user may need to perform weighted aggregations for moving up in scale and apply weights to splits. 
  
  if (is.null(shapefile) && !is.null(key)) {
    
    #check if Jihyeon agrees about need for data2 argument
    crosswalk_data(data = data,
                   data2 = data2,
                   source_scale = source_scale,
                   key = key, 
                   target_scale = target_scale)
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
  
  else {
    stop("data and shapefile passed to the crosswalk() function are both null.\n
         At least one must be non-null")
  }
}