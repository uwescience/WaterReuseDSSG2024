# Jihyeon's code

setwd(config::get("home_path"))

source("./map_utils/crosswalks.R")

# Nora's code

# source()

crosswalk <- function(data = NULL, 
                      shapefile = NULL, 
                      source_scale = NULL, 
                      key = NULL, 
                      target_scale = NULL) {
  
  if (is.null(shapefile) && !is.null(key)) {
    
    crosswalk_data(data = data, 
                   source_scale = source_scale,
                   key = key, 
                   target_scale = target_scale)
  }
  
  else if (is.null(data)) {
    
    crosswalk_geom(shapefile = shapefile, 
                   data = data, 
                   source_scale = source_scale,
                   target_scale = target_scale)
  }
  
  else {
    stop("data and shapefile passed to the crosswalk() function are both null.\n
         At least one must be non-null")
  }
}