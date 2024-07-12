# Jihyeon's code

setwd(config::get("home_path"))

source("./map_utils/crosswalks.R")

# Nora's code

# source()

crosswalk <- function(data = NULL, 
                      shapefile = NULL, 
                      source_scale = NULL, 
                      key = NULL, 
                      target_scale = NULL,
                      typeof) {
  # Args: 
    # source_scale: if data contains points given by latitude and longitude, source scale must contain those column names c("lat", "lon")
  
  if (is.null(shapefile) && !is.null(key) && typeof == "ID") {
    
    crosswalk_data(data = data, 
                   source_scale = source_scale,
                   key = key, 
                   target_scale = target_scale)
  }
  
  else if (!is.null(shapefile) && !is.null(data) && is.null(key)) {
    
    crosswalk_geom(shapefile = shapefile, 
                   data = data, 
                   location_columns = source_scale,
                   type = typeof)
  }
  
  else {
    stop("data and shapefile passed to the crosswalk() function are both null.\n
         At least one must be non-null")
  }
}